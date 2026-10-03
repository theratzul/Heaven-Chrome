package com.heavenchrome;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.SourceDataLine;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * SoundSynth - Pure procedural tone synthesizer for Heaven Chrome Java.
 * Uses javax.sound.sampled with zero external dependencies.
 */
public class SoundSynth {
    private static final int SAMPLE_RATE = 22050;
    private final ExecutorService soundPool = Executors.newSingleThreadExecutor();
    private boolean muted = false;
    private boolean timeSlow = false;

    public void setMuted(boolean muted) {
        this.muted = muted;
    }

    public boolean isMuted() {
        return muted;
    }

    public void toggleMute() {
        this.muted = !this.muted;
    }

    public void setTimeSlow(boolean slow) {
        this.timeSlow = slow;
    }

    private void playTone(final double startFreq, final double endFreq, final int durationMs, final double volume) {
        if (muted) return;

        soundPool.submit(() -> {
            try {
                AudioFormat format = new AudioFormat(SAMPLE_RATE, 8, 1, false, false);
                SourceDataLine line = AudioSystem.getSourceDataLine(format);
                line.open(format, 1024);
                line.start();

                int totalSamples = (SAMPLE_RATE * durationMs) / 1000;
                byte[] buffer = new byte[totalSamples];
                double phase = 0.0;

                for (int i = 0; i < totalSamples; i++) {
                    double progress = (double) i / totalSamples;
                    double freq = startFreq + (endFreq - startFreq) * progress;
                    if (timeSlow) {
                        freq *= 0.6; // Deep celestial pitch shift during divine slow
                    }
                    phase += 2.0 * Math.PI * freq / SAMPLE_RATE;
                    // Envelope attack/decay
                    double env = 1.0;
                    if (progress < 0.1) env = progress / 0.1;
                    else if (progress > 0.8) env = (1.0 - progress) / 0.2;

                    byte sample = (byte) (128 + (Math.sin(phase) * 120.0 * volume * env));
                    buffer[i] = sample;
                }

                line.write(buffer, 0, buffer.length);
                line.drain();
                line.close();
            } catch (Exception ignored) {
            }
        });
    }

    public void playAngelChime() {
        soundPool.submit(() -> {
            int[] freqs = {523, 659, 784, 1046}; // C5, E5, G5, C6
            for (int f : freqs) {
                playTone(f, f + 20, 60, 0.4);
                try {
                    Thread.sleep(40);
                } catch (InterruptedException ignored) {
                }
            }
        });
    }

    public void playTimeShift() {
        playTone(300, 700, 180, 0.35);
    }

    public void playHazardHit() {
        playTone(180, 70, 220, 0.5);
    }

    public void playLevelWin() {
        soundPool.submit(() -> {
            int[] freqs = {440, 554, 659, 880, 1108};
            for (int f : freqs) {
                playTone(f, f, 100, 0.4);
                try {
                    Thread.sleep(70);
                } catch (InterruptedException ignored) {
                }
            }
        });
    }

    public void shutdown() {
        soundPool.shutdownNow();
    }
}
