/* audio.h - Divine MIDI Synthesizer & Sound Effects for Linux (SDL2) */
#ifndef AUDIO_H
#define AUDIO_H

#include <stdint.h>
#include <stdbool.h>

void audio_init(void);
void audio_shutdown(void);
void audio_set_time_slow(bool is_slow);
void audio_toggle_mute(void);
bool audio_is_muted(void);

/* Sound effects */
void audio_play_angel_chime(void);
void audio_play_hazard_hit(void);
void audio_play_time_shift(void);
void audio_play_level_win(void);

#endif /* AUDIO_H */
