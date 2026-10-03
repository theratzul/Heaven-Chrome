package com.heavenchrome;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class GameEngine {
    public static final int GRID_WIDTH = 32;
    public static final int GRID_HEIGHT = 24;
    public static final int TILE_SIZE = 25;
    public static final int SCREEN_W = GRID_WIDTH * TILE_SIZE; // 800
    public static final int SCREEN_H = GRID_HEIGHT * TILE_SIZE; // 600

    public enum State {
        TITLE,
        PLAYING,
        PAUSED,
        GAMEOVER,
        LEVELWIN,
        VICTORY
    }

    public static class Particle {
        public float x, y, vx, vy;
        public float life, maxLife;
        public int r, g, b, a;
        public float size;

        public Particle(float x, float y, float vx, float vy, float life, int r, int g, int b, float size) {
            this.x = x;
            this.y = y;
            this.vx = vx;
            this.vy = vy;
            this.life = life;
            this.maxLife = life;
            this.r = r;
            this.g = g;
            this.b = b;
            this.a = 255;
            this.size = size;
        }
    }

    public State state = State.TITLE;
    public int currentLevel = 0;
    public long score = 0;
    public int lives = 3;
    public float energy = 100.0f;
    public final float maxEnergy = 100.0f;
    public boolean isSlow = false;
    public float stateTimer = 0.0f;
    public float sunrayAngle = 0.0f;

    public float playerX = 2.0f;
    public float playerY = 20.0f;
    public float playerVx = 0.0f;
    public float playerVy = 0.0f;
    public int playerInvincible = 0;

    public int[][] currentMap = new int[GRID_HEIGHT][GRID_WIDTH];
    public final List<Particle> particles = new ArrayList<>();
    private final Random rand = new Random();
    public final SoundSynth synth = new SoundSynth();

    public GameEngine() {
        init();
    }

    public void init() {
        state = State.TITLE;
        currentLevel = 0;
        score = 0;
        lives = 3;
        energy = 100.0f;
        isSlow = false;
        particles.clear();
    }

    public void reset() {
        currentLevel = 0;
        score = 0;
        lives = 3;
        energy = 100.0f;
        isSlow = false;
        synth.setTimeSlow(false);
        startLevel(0);
        state = State.PLAYING;
    }

    public void startLevel(int levelIdx) {
        if (levelIdx < 0) levelIdx = 0;
        if (levelIdx >= LevelsData.LEVEL_COUNT) levelIdx = LevelsData.LEVEL_COUNT - 1;

        currentLevel = levelIdx;
        for (int r = 0; r < GRID_HEIGHT; r++) {
            System.arraycopy(LevelsData.LEVELS[levelIdx][r], 0, currentMap[r], 0, GRID_WIDTH);
        }

        playerX = 2.0f;
        playerY = 20.0f;
        playerVx = 0.0f;
        playerVy = 0.0f;
        playerInvincible = 60;
        isSlow = false;
        synth.setTimeSlow(false);

        // Burst particles at entrance
        for (int i = 0; i < 20; i++) {
            float angle = (float) (rand.nextDouble() * Math.PI * 2);
            float spd = 20.0f + rand.nextFloat() * 40.0f;
            spawnParticle(
                playerX * TILE_SIZE + TILE_SIZE / 2.0f,
                playerY * TILE_SIZE + TILE_SIZE / 2.0f,
                (float) Math.cos(angle) * spd,
                (float) Math.sin(angle) * spd,
                0.6f + rand.nextFloat() * 0.4f,
                255, 235, 120, 4.0f
            );
        }
    }

    public void spawnParticle(float x, float y, float vx, float vy, float life, int r, int g, int b, float size) {
        if (particles.size() >= 200) {
            particles.remove(0);
        }
        particles.add(new Particle(x, y, vx, vy, life, r, g, b, size));
    }

    public void setTimeSlow(boolean slow) {
        if (state != State.PLAYING) return;

        if (slow && energy > 5.0f) {
            if (!isSlow) {
                synth.playTimeShift();
            }
            isSlow = true;
            synth.setTimeSlow(true);
        } else {
            isSlow = false;
            synth.setTimeSlow(false);
        }
    }

    public void togglePause() {
        if (state == State.PLAYING) {
            state = State.PAUSED;
        } else if (state == State.PAUSED) {
            state = State.PLAYING;
        }
    }

    public void startOrRespawn() {
        if (state == State.TITLE) {
            reset();
        } else if (state == State.PAUSED) {
            state = State.PLAYING;
        } else if (state == State.GAMEOVER) {
            reset();
        } else if (state == State.VICTORY) {
            state = State.TITLE;
        }
    }

    public void handleMove(int dx, int dy) {
        if (state != State.PLAYING) return;
        float speed = 5.2f;
        playerVx = dx * speed;
        playerVy = dy * speed;
    }

    public void update(float dt) {
        sunrayAngle += dt * 0.15f;
        if (sunrayAngle > Math.PI * 2) sunrayAngle -= Math.PI * 2;

        // Update particles
        for (int i = particles.size() - 1; i >= 0; i--) {
            Particle p = particles.get(i);
            p.life -= dt;
            if (p.life <= 0.0f) {
                particles.remove(i);
                continue;
            }
            p.x += p.vx * dt;
            p.y += p.vy * dt;
            p.a = (int) ((p.life / p.maxLife) * 255.0f);
        }

        if (state == State.LEVELWIN) {
            stateTimer -= dt;
            if (stateTimer <= 0.0f) {
                currentLevel++;
                if (currentLevel >= LevelsData.LEVEL_COUNT) {
                    state = State.VICTORY;
                } else {
                    startLevel(currentLevel);
                    state = State.PLAYING;
                }
            }
            return;
        }

        if (state != State.PLAYING) return;

        // Divine slow energy management
        if (isSlow) {
            energy -= dt * 25.0f;
            if (energy <= 0.0f) {
                energy = 0.0f;
                isSlow = false;
                synth.setTimeSlow(false);
            }
        } else {
            if (energy < maxEnergy) {
                energy += dt * 15.0f;
                if (energy > maxEnergy) energy = maxEnergy;
            }
        }

        if (playerInvincible > 0) {
            playerInvincible--;
        }

        // Apply movement with axis-independent collision: walls & platforms are impassable obstacles
        float targetX = playerX + playerVx * dt;
        float targetY = playerY + playerVy * dt;

        if (targetX < 1.0f) targetX = 1.0f;
        if (targetX > GRID_WIDTH - 2.0f) targetX = GRID_WIDTH - 2.0f;
        if (targetY < 1.0f) targetY = 1.0f;
        if (targetY > GRID_HEIGHT - 2.0f) targetY = GRID_HEIGHT - 2.0f;

        int testX = (int) (targetX + 0.5f);
        int currY = (int) (playerY + 0.5f);
        int tileX = currentMap[currY][testX];
        if (tileX != LevelsData.TILE_WALL && tileX != LevelsData.TILE_PLATFORM) {
            playerX = targetX;
        }

        int currX = (int) (playerX + 0.5f);
        int testY = (int) (targetY + 0.5f);
        int tileY = currentMap[testY][currX];
        if (tileY != LevelsData.TILE_WALL && tileY != LevelsData.TILE_PLATFORM) {
            playerY = targetY;
        }

        int px = (int) (playerX + 0.5f);
        int py = (int) (playerY + 0.5f);
        int tile = currentMap[py][px];

        // Angel collectible
        if (tile == LevelsData.TILE_ANGEL) {
            currentMap[py][px] = LevelsData.TILE_EMPTY;
            score += 500;
            synth.playAngelChime();

            for (int i = 0; i < 30; i++) {
                float angle = (float) (rand.nextDouble() * Math.PI * 2);
                float spd = 30.0f + rand.nextFloat() * 60.0f;
                spawnParticle(
                    px * TILE_SIZE + TILE_SIZE / 2.0f,
                    py * TILE_SIZE + TILE_SIZE / 2.0f,
                    (float) Math.cos(angle) * spd,
                    (float) Math.sin(angle) * spd,
                    0.8f,
                    255, 215, 0, 5.0f
                );
            }
        }

        // Exit Pearly Gate
        if (tile == LevelsData.TILE_EXIT) {
            score += 1000;
            synth.playLevelWin();
            state = State.LEVELWIN;
            stateTimer = 1.6f;

            for (int i = 0; i < 40; i++) {
                float angle = (float) (rand.nextDouble() * Math.PI * 2);
                float spd = 40.0f + rand.nextFloat() * 80.0f;
                spawnParticle(
                    playerX * TILE_SIZE + TILE_SIZE / 2.0f,
                    playerY * TILE_SIZE + TILE_SIZE / 2.0f,
                    (float) Math.cos(angle) * spd,
                    (float) Math.sin(angle) * spd,
                    1.2f,
                    255, 255, 255, 6.0f
                );
            }
            return;
        }

        // Hazard Collision
        if (tile == LevelsData.TILE_HAZARD && playerInvincible == 0) {
            lives--;
            synth.playHazardHit();

            for (int i = 0; i < 25; i++) {
                float angle = (float) (rand.nextDouble() * Math.PI * 2);
                float spd = 20.0f + rand.nextFloat() * 50.0f;
                spawnParticle(
                    playerX * TILE_SIZE + TILE_SIZE / 2.0f,
                    playerY * TILE_SIZE + TILE_SIZE / 2.0f,
                    (float) Math.cos(angle) * spd,
                    (float) Math.sin(angle) * spd,
                    0.6f,
                    255, 50, 50, 4.0f
                );
            }

            if (lives <= 0) {
                state = State.GAMEOVER;
            } else {
                playerX = 2.0f;
                playerY = 20.0f;
                playerInvincible = 90;
            }
        }

        // Particle trail
        if (rand.nextInt(3) == 0) {
            spawnParticle(
                playerX * TILE_SIZE + TILE_SIZE / 2.0f + (rand.nextFloat() * 8.0f - 4.0f),
                playerY * TILE_SIZE + TILE_SIZE / 2.0f + (rand.nextFloat() * 8.0f - 4.0f),
                -playerVx * 0.2f, -playerVy * 0.2f,
                0.5f,
                255, 240, 180, 3.5f
            );
        }
    }
}
