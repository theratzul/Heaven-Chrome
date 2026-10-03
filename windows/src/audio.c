/* audio.c - Divine MIDI Synthesizer & Sound Effects for Linux (SDL2) */
#include "audio.h"
#include <SDL2/SDL.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#define SAMPLE_RATE 44100
#define PI 3.14159265358979323846

static SDL_AudioDeviceID g_audio_device = 0;
static bool g_muted = false;
static bool g_time_slow = false;
static double g_audio_pitch_scale = 1.0;

/* Note frequencies (Hz) */
static const float C3 = 130.81f, F3 = 174.61f, G3 = 196.00f, A3 = 220.00f, B3 = 246.94f;
static const float C4 = 261.63f, D4 = 293.66f, E4 = 329.63f, F4 = 349.23f, G4 = 392.00f, A4 = 440.00f;
static const float C5 = 523.25f, D5 = 587.33f, E5 = 659.25f, F5 = 698.46f, G5 = 783.99f, A5 = 880.00f, B5 = 987.77f;
static const float C6 = 1046.50f, G6 = 1567.98f;

/* Lead melody notes (Sacred Hymn) */
static const float g_lead_melody[] = {
    C5, E5, G5, E5, F5, A5, G5, E5,
    D5, F5, E5, C5, D5, G4, C5, C5,
    G5, E5, A5, F5, G5, E5, D5, G4,
    C5, E5, G5, C6, B5, G5, C6, C6
};
#define MELODY_LENGTH (sizeof(g_lead_melody) / sizeof(g_lead_melody[0]))

/* Bass chords corresponding to melody bars */
static const float g_bass_notes[] = {
    C3, C3, F3, C3, G3, A3, G3, C3,
    C3, A3, F3, C3, G3, G3, C3, C3
};
#define BASS_LENGTH (sizeof(g_bass_notes) / sizeof(g_bass_notes[0]))

/* Harp arpeggios offsets */
static const float g_harp_scales[][4] = {
    {C4, E4, G4, C5},
    {F3, A3, C4, F4},
    {G3, B3, D4, G4},
    {A3, C4, E4, A4}
};

/* Synthesis state */
static double g_melody_step = 0.0;
static double g_lead_phase = 0.0;
static double g_bass_phase = 0.0;
static double g_harp_phase = 0.0;

/* Sound Effect triggers (samples remaining) */
static int g_sfx_chime_samples = 0;
static int g_sfx_hit_samples = 0;
static int g_sfx_shift_samples = 0;
static int g_sfx_win_samples = 0;

static double g_sfx_chime_phase = 0.0;
static double g_sfx_shift_phase = 0.0;
static double g_sfx_win_phase = 0.0;

/* Audio callback: fills the stereo 16-bit PCM buffer */
static void audio_callback(void *userdata, Uint8 *stream, int len)
{
    (void)userdata;
    int16_t *buf = (int16_t *)stream;
    int sample_count = len / (2 * sizeof(int16_t)); /* Stereo: 2 channels */

    if (g_muted) {
        memset(stream, 0, len);
        return;
    }

    /* Smoothly interpolate pitch scale when time slow is active */
    double target_scale = g_time_slow ? 0.45 : 1.0;
    
    for (int i = 0; i < sample_count; ++i) {
        g_audio_pitch_scale += (target_scale - g_audio_pitch_scale) * 0.002;

        /* Tempo: calculate current position in melody */
        double samples_per_beat = (SAMPLE_RATE * 0.28) / g_audio_pitch_scale;
        g_melody_step += 1.0;
        int current_beat = (int)(g_melody_step / samples_per_beat) % MELODY_LENGTH;
        int harp_sub_step = (int)(g_melody_step / (samples_per_beat / 4.0)) % 4;
        int bass_bar = (int)(g_melody_step / (samples_per_beat * 2.0)) % BASS_LENGTH;

        /* Note frequencies */
        float lead_freq = g_lead_melody[current_beat] * (float)g_audio_pitch_scale;
        float bass_freq = g_bass_notes[bass_bar] * (float)g_audio_pitch_scale;
        
        int scale_idx = (current_beat / 4) % 4;
        float harp_freq = g_harp_scales[scale_idx][harp_sub_step] * (float)g_audio_pitch_scale;

        /* Lead channel: Triangle wave */
        g_lead_phase += (2.0 * PI * lead_freq) / SAMPLE_RATE;
        if (g_lead_phase >= 2.0 * PI) g_lead_phase -= 2.0 * PI;
        double tri = (2.0 / PI) * asin(sin(g_lead_phase));

        /* Bass channel: Soft Sawtooth + Sine */
        g_bass_phase += (2.0 * PI * bass_freq) / SAMPLE_RATE;
        if (g_bass_phase >= 2.0 * PI) g_bass_phase -= 2.0 * PI;
        double bass = (sin(g_bass_phase) + (g_bass_phase / PI - 1.0) * 0.3) * 0.6;

        /* Harp channel: Sine arpeggios */
        g_harp_phase += (2.0 * PI * harp_freq) / SAMPLE_RATE;
        if (g_harp_phase >= 2.0 * PI) g_harp_phase -= 2.0 * PI;
        double harp = sin(g_harp_phase) * 0.35;

        /* Combine BGM */
        double mix = (tri * 0.28) + (bass * 0.22) + (harp * 0.16);

        /* SFX 1: Angel Chime */
        if (g_sfx_chime_samples > 0) {
            float progress = 1.0f - ((float)g_sfx_chime_samples / (SAMPLE_RATE * 0.6f));
            float freq = C6 + progress * (G6 - C6);
            g_sfx_chime_phase += (2.0 * PI * freq) / SAMPLE_RATE;
            mix += sin(g_sfx_chime_phase) * (1.0f - progress) * 0.45;
            g_sfx_chime_samples--;
        }

        /* SFX 2: Hazard Hit */
        if (g_sfx_hit_samples > 0) {
            float progress = (float)g_sfx_hit_samples / (SAMPLE_RATE * 0.3f);
            float noise = ((float)rand() / (float)RAND_MAX * 2.0f - 1.0f);
            mix += noise * progress * 0.35;
            g_sfx_hit_samples--;
        }

        /* SFX 3: Time Shift Warp */
        if (g_sfx_shift_samples > 0) {
            float progress = 1.0f - ((float)g_sfx_shift_samples / (SAMPLE_RATE * 0.25f));
            float freq = 200.0f + sin(progress * PI) * 600.0f;
            g_sfx_shift_phase += (2.0 * PI * freq) / SAMPLE_RATE;
            mix += sin(g_sfx_shift_phase) * 0.25;
            g_sfx_shift_samples--;
        }

        /* SFX 4: Level Win Fanfare */
        if (g_sfx_win_samples > 0) {
            float progress = 1.0f - ((float)g_sfx_win_samples / (SAMPLE_RATE * 1.2f));
            float notes[] = {C5, E5, G5, C6};
            int n_idx = (int)(progress * 4) % 4;
            g_sfx_win_phase += (2.0 * PI * notes[n_idx]) / SAMPLE_RATE;
            mix += sin(g_sfx_win_phase) * (1.0f - progress * 0.5f) * 0.4;
            g_sfx_win_samples--;
        }

        /* Soft clipping */
        if (mix > 0.95) mix = 0.95;
        if (mix < -0.95) mix = -0.95;

        int16_t sample_val = (int16_t)(mix * 30000.0);
        buf[i * 2] = sample_val;     /* Left */
        buf[i * 2 + 1] = sample_val; /* Right */
    }
}

void audio_init(void)
{
    SDL_AudioSpec desired, obtained;
    SDL_zero(desired);
    desired.freq = SAMPLE_RATE;
    desired.format = AUDIO_S16SYS;
    desired.channels = 2;
    desired.samples = 1024;
    desired.callback = audio_callback;

    g_audio_device = SDL_OpenAudioDevice(NULL, 0, &desired, &obtained, 0);
    if (g_audio_device > 0) {
        SDL_PauseAudioDevice(g_audio_device, 0); /* Start playing */
    }
}

void audio_shutdown(void)
{
    if (g_audio_device > 0) {
        SDL_CloseAudioDevice(g_audio_device);
        g_audio_device = 0;
    }
}

void audio_set_time_slow(bool is_slow)
{
    g_time_slow = is_slow;
}

void audio_toggle_mute(void)
{
    g_muted = !g_muted;
}

bool audio_is_muted(void)
{
    return g_muted;
}

void audio_play_angel_chime(void)
{
    g_sfx_chime_samples = (int)(SAMPLE_RATE * 0.6);
}

void audio_play_hazard_hit(void)
{
    g_sfx_hit_samples = (int)(SAMPLE_RATE * 0.3);
}

void audio_play_time_shift(void)
{
    g_sfx_shift_samples = (int)(SAMPLE_RATE * 0.25);
}

void audio_play_level_win(void)
{
    g_sfx_win_samples = (int)(SAMPLE_RATE * 1.2);
}
