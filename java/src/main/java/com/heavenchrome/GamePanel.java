package com.heavenchrome;

import javax.swing.*;
import java.awt.*;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.geom.Ellipse2D;
import java.awt.geom.RoundRectangle2D;
import java.util.HashSet;
import java.util.Set;

public class GamePanel extends JPanel {
    private final GameEngine engine;
    private final Set<Integer> activeKeys = new HashSet<>();
    private Timer gameLoopTimer;

    public GamePanel(GameEngine engine) {
        this.engine = engine;
        setPreferredSize(new Dimension(GameEngine.SCREEN_W, GameEngine.SCREEN_H));
        setBackground(new Color(19, 78, 124));
        setFocusable(true);

        setupKeyBindings();
        startGameLoop();
    }

    private void setupKeyBindings() {
        addKeyListener(new KeyAdapter() {
            @Override
            public void keyPressed(KeyEvent e) {
                int key = e.getKeyCode();
                activeKeys.add(key);

                if (key == KeyEvent.VK_SPACE) {
                    if (engine.state == GameEngine.State.PLAYING) {
                        engine.setTimeSlow(true);
                    } else {
                        engine.startOrRespawn();
                    }
                } else if (key == KeyEvent.VK_P || key == KeyEvent.VK_ESCAPE) {
                    engine.togglePause();
                } else if (key == KeyEvent.VK_M) {
                    engine.synth.toggleMute();
                } else if (key == KeyEvent.VK_R) {
                    engine.reset();
                }
            }

            @Override
            public void keyReleased(KeyEvent e) {
                int key = e.getKeyCode();
                activeKeys.remove(key);

                if (key == KeyEvent.VK_SPACE) {
                    engine.setTimeSlow(false);
                }
            }
        });
    }

    private void startGameLoop() {
        // 60 FPS update loop
        gameLoopTimer = new Timer(16, e -> {
            updateInput();
            float dt = engine.isSlow ? 0.006f : 0.016f;
            engine.update(dt);
            repaint();
        });
        gameLoopTimer.start();
    }

    private void updateInput() {
        if (engine.state != GameEngine.State.PLAYING) return;

        int dx = 0;
        int dy = 0;

        if (activeKeys.contains(KeyEvent.VK_LEFT) || activeKeys.contains(KeyEvent.VK_A)) dx -= 1;
        if (activeKeys.contains(KeyEvent.VK_RIGHT) || activeKeys.contains(KeyEvent.VK_D)) dx += 1;
        if (activeKeys.contains(KeyEvent.VK_UP) || activeKeys.contains(KeyEvent.VK_W)) dy -= 1;
        if (activeKeys.contains(KeyEvent.VK_DOWN) || activeKeys.contains(KeyEvent.VK_S)) dy += 1;

        engine.handleMove(dx, dy);
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        Graphics2D g2 = (Graphics2D) g;
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);

        drawBackground(g2);
        drawSunrays(g2);
        drawMap(g2);
        drawParticles(g2);

        if (engine.state == GameEngine.State.PLAYING || engine.state == GameEngine.State.PAUSED || engine.state == GameEngine.State.LEVELWIN) {
            drawPlayer(g2);
            drawHud(g2);
        }

        drawOverlays(g2);
    }

    private void drawBackground(Graphics2D g2) {
        GradientPaint gradient = new GradientPaint(
            0, 0, new Color(19, 78, 124),
            0, getHeight(), new Color(179, 229, 252)
        );
        g2.setPaint(gradient);
        g2.fillRect(0, 0, getWidth(), getHeight());
    }

    private void drawSunrays(Graphics2D g2) {
        int cx = getWidth() / 2;
        int cy = -100;
        int rayCount = 18;
        float baseAngle = engine.sunrayAngle;

        g2.setColor(new Color(255, 255, 255, 18));
        for (int i = 0; i < rayCount; i++) {
            if (i % 2 == 0) continue;
            double a1 = baseAngle + i * (Math.PI * 2 / rayCount);
            double a2 = a1 + (Math.PI * 2 / rayCount);

            Polygon poly = new Polygon();
            poly.addPoint(cx, cy);
            poly.addPoint((int) (cx + Math.cos(a1) * 900), (int) (cy + Math.sin(a1) * 900));
            poly.addPoint((int) (cx + Math.cos(a2) * 900), (int) (cy + Math.sin(a2) * 900));
            g2.fill(poly);
        }
    }

    private void drawMap(Graphics2D g2) {
        int ts = GameEngine.TILE_SIZE;
        for (int y = 0; y < GameEngine.GRID_HEIGHT; y++) {
            for (int x = 0; x < GameEngine.GRID_WIDTH; x++) {
                int tile = engine.currentMap[y][x];
                int px = x * ts;
                int py = y * ts;

                if (tile == LevelsData.TILE_WALL) {
                    g2.setColor(new Color(139, 101, 8));
                    g2.fillRect(px, py, ts, ts);
                    g2.setColor(new Color(218, 165, 32));
                    g2.drawRect(px, py, ts, ts);
                    g2.setColor(new Color(255, 215, 0, 70));
                    g2.drawLine(px, py, px + ts, py);
                    g2.drawLine(px, py, px, py + ts);
                } else if (tile == LevelsData.TILE_PLATFORM) {
                    g2.setColor(new Color(255, 255, 255, 230));
                    g2.fill(new RoundRectangle2D.Float(px, py + 6, ts, ts - 10, 6, 6));
                    g2.setColor(new Color(255, 225, 100, 240));
                    g2.drawLine(px, py + 6, px + ts, py + 6);
                } else if (tile == LevelsData.TILE_HAZARD) {
                    g2.setColor(new Color(220, 20, 60));
                    g2.fillRect(px + 10, py + 4, 5, ts - 8);
                    g2.fillRect(px + 4, py + 8, ts - 8, 5);
                    g2.setColor(new Color(255, 100, 100, 200));
                    g2.drawRect(px + 4, py + 8, ts - 8, 5);
                } else if (tile == LevelsData.TILE_EXIT) {
                    g2.setColor(new Color(255, 215, 0));
                    g2.drawRoundRect(px + 2, py + 2, ts - 4, ts - 4, 8, 8);
                    g2.setColor(new Color(224, 255, 255, 230));
                    g2.fillRoundRect(px + 6, py + 6, ts - 12, ts - 12, 6, 6);
                } else if (tile == LevelsData.TILE_ANGEL) {
                    int acx = px + ts / 2;
                    int acy = py + ts / 2;
                    // Golden Halo
                    g2.setColor(new Color(255, 215, 0));
                    g2.drawOval(acx - 5, acy - 9, 10, 3);
                    // Wings
                    g2.setColor(new Color(255, 255, 255, 230));
                    g2.drawLine(acx - 7, acy - 3, acx - 1, acy + 2);
                    g2.drawLine(acx + 7, acy - 3, acx + 1, acy + 2);
                    // Robe
                    g2.fillRect(acx - 2, acy - 4, 5, 8);
                }
            }
        }
    }

    private void drawParticles(Graphics2D g2) {
        for (GameEngine.Particle p : engine.particles) {
            g2.setColor(new Color(p.r, p.g, p.b, Math.max(0, Math.min(255, p.a))));
            g2.fill(new Ellipse2D.Float(p.x, p.y, p.size, p.size));
        }
    }

    private void drawPlayer(Graphics2D g2) {
        int px = (int) (engine.playerX * GameEngine.TILE_SIZE);
        int py = (int) (engine.playerY * GameEngine.TILE_SIZE);
        int cx = px + GameEngine.TILE_SIZE / 2;
        int cy = py + GameEngine.TILE_SIZE / 2;

        if (engine.playerInvincible > 0 && (engine.playerInvincible / 4) % 2 == 1) {
            return; // Invincibility flash
        }

        // Divine golden aura
        g2.setColor(new Color(255, 215, 0, 80));
        g2.fillOval(cx - 14, cy - 14, 28, 28);

        // Radiant white orb
        g2.setColor(Color.WHITE);
        g2.fillOval(cx - 8, cy - 8, 16, 16);

        // Core halo
        g2.setColor(new Color(255, 215, 0));
        g2.drawOval(cx - 6, cy - 12, 12, 4);
    }

    private void drawHud(Graphics2D g2) {
        // Banner
        g2.setColor(new Color(255, 255, 255, 235));
        g2.fillRoundRect(10, 2, getWidth() - 20, 24, 6, 6);
        g2.setColor(new Color(255, 215, 0));
        g2.drawRoundRect(10, 2, getWidth() - 20, 24, 6, 6);

        g2.setFont(new Font("Monospaced", Font.BOLD, 13));
        g2.setColor(new Color(139, 101, 8));

        // Realm
        g2.drawString(String.format("REALM: %d/%d", engine.currentLevel + 1, LevelsData.LEVEL_COUNT), 22, 19);

        // Faith
        g2.setColor(new Color(184, 134, 11));
        g2.drawString(String.format("FAITH: %d", engine.score), 170, 19);

        // Souls
        g2.setColor(new Color(139, 101, 8));
        g2.drawString(String.format("SOULS: %d", engine.lives), 330, 19);

        // Grace bar
        g2.drawString("GRACE:", 440, 19);
        g2.setColor(new Color(200, 200, 200, 180));
        g2.fillRect(500, 8, 100, 12);
        g2.setColor(new Color(255, 215, 0));
        g2.drawRect(500, 8, 100, 12);

        int fillW = (int) ((engine.energy / engine.maxEnergy) * 96.0f);
        if (fillW > 0) {
            g2.setColor(new Color(255, 200, 0));
            g2.fillRect(502, 10, fillW, 8);
        }

        // Audio
        String audioStr = engine.synth.isMuted() ? "MUTED [M]" : "AUDIO [M]";
        g2.drawString(audioStr, 670, 19);
    }

    private void drawCenteredString(Graphics2D g2, String text, int y, Font font, Color color) {
        g2.setFont(font);
        g2.setColor(color);
        FontMetrics fm = g2.getFontMetrics();
        int x = (getWidth() - fm.stringWidth(text)) / 2;
        g2.drawString(text, x, y);
    }

    private void drawOverlays(Graphics2D g2) {
        Color dark = new Color(139, 101, 8);
        Color gold = new Color(218, 165, 32);
        Color blue = new Color(30, 136, 229);
        Color red = new Color(220, 20, 60);

        if (engine.state == GameEngine.State.TITLE) {
            // Main Card
            g2.setColor(new Color(255, 255, 255, 240));
            g2.fillRoundRect(100, 50, 600, 500, 16, 16);
            g2.setColor(new Color(255, 215, 0));
            g2.setStroke(new BasicStroke(2));
            g2.drawRoundRect(100, 50, 600, 500, 16, 16);

            drawCenteredString(g2, "HEAVEN CHROME", 95, new Font("SansSerif", Font.BOLD, 32), dark);
            drawCenteredString(g2, "A Divine Time-Bending Journey", 130, new Font("SansSerif", Font.BOLD, 18), blue);
            drawCenteredString(g2, "BY POPA BOGDAN", 155, new Font("Monospaced", Font.BOLD, 14), gold);

            // Controls Box
            g2.setColor(new Color(255, 248, 220, 240));
            g2.fillRoundRect(140, 180, 520, 185, 12, 12);
            g2.setColor(gold);
            g2.drawRoundRect(140, 180, 520, 185, 12, 12);

            g2.setFont(new Font("Monospaced", Font.BOLD, 13));
            g2.setColor(dark);
            g2.drawString("MOVE:       WASD / Arrow Keys", 170, 210);
            g2.drawString("SLOW TIME:  Hold SPACE Bar", 170, 240);
            g2.drawString("PAUSE:      P or Escape Key", 170, 270);
            g2.drawString("MUTE AUDIO: M Key", 170, 300);
            g2.drawString("OBJECTIVE:  Ascend 20 Divine Realms to Paradise", 170, 335);

            // Button
            g2.setColor(new Color(255, 200, 0));
            g2.fillRoundRect(140, 390, 520, 52, 12, 12);
            g2.setColor(gold);
            g2.drawRoundRect(140, 390, 520, 52, 12, 12);

            drawCenteredString(g2, "PRESS SPACE TO ASCEND", 423, new Font("SansSerif", Font.BOLD, 20), Color.WHITE);
            drawCenteredString(g2, "Desktop Java Edition - OpenJDK 21", 470, new Font("Monospaced", Font.BOLD, 13), gold);
            drawCenteredString(g2, "Press [M] to Toggle Audio", 495, new Font("Monospaced", Font.PLAIN, 12), dark);

        } else if (engine.state == GameEngine.State.PAUSED) {
            g2.setColor(new Color(255, 255, 255, 235));
            g2.fillRoundRect(180, 170, 440, 240, 14, 14);
            g2.setColor(gold);
            g2.drawRoundRect(180, 170, 440, 240, 14, 14);

            drawCenteredString(g2, "CONTEMPLATION", 220, new Font("SansSerif", Font.BOLD, 28), dark);
            drawCenteredString(g2, "Journey Paused", 265, new Font("SansSerif", Font.BOLD, 18), blue);
            drawCenteredString(g2, "Press P, SPACE, or ESC to Resume", 315, new Font("Monospaced", Font.BOLD, 14), dark);
            drawCenteredString(g2, "Press M to Toggle Audio", 345, new Font("Monospaced", Font.PLAIN, 13), gold);

        } else if (engine.state == GameEngine.State.GAMEOVER) {
            g2.setColor(new Color(255, 255, 255, 240));
            g2.fillRoundRect(130, 140, 540, 290, 14, 14);
            g2.setColor(red);
            g2.drawRoundRect(130, 140, 540, 290, 14, 14);

            drawCenteredString(g2, "FALLEN", 190, new Font("SansSerif", Font.BOLD, 36), red);
            drawCenteredString(g2, "Your soul yearns to ascend again", 235, new Font("SansSerif", Font.PLAIN, 16), dark);
            drawCenteredString(g2, String.format("Reached Realm %d  -  Faith Score: %d", engine.currentLevel + 1, engine.score), 268, new Font("Monospaced", Font.BOLD, 15), blue);

            g2.setColor(red);
            g2.fillRoundRect(140, 310, 520, 50, 10, 10);
            g2.setColor(gold);
            g2.drawRoundRect(140, 310, 520, 50, 10, 10);

            drawCenteredString(g2, "PRESS SPACE TO RESURRECT", 342, new Font("SansSerif", Font.BOLD, 20), Color.WHITE);

        } else if (engine.state == GameEngine.State.LEVELWIN) {
            g2.setColor(new Color(255, 255, 255, 240));
            g2.fillRoundRect(160, 190, 480, 190, 14, 14);
            g2.setColor(gold);
            g2.drawRoundRect(160, 190, 480, 190, 14, 14);

            drawCenteredString(g2, "REALM CLEARED!", 240, new Font("SansSerif", Font.BOLD, 28), gold);
            drawCenteredString(g2, String.format("Ascending to Realm %d of %d...", engine.currentLevel + 2, LevelsData.LEVEL_COUNT), 285, new Font("SansSerif", Font.BOLD, 16), blue);
            drawCenteredString(g2, "Faith preserved - Grace restored", 325, new Font("Monospaced", Font.PLAIN, 14), dark);

        } else if (engine.state == GameEngine.State.VICTORY) {
            g2.setColor(new Color(255, 255, 255, 245));
            g2.fillRoundRect(140, 120, 520, 340, 16, 16);
            g2.setColor(gold);
            g2.drawRoundRect(140, 120, 520, 340, 16, 16);

            drawCenteredString(g2, "PARADISE ATTAINED!", 165, new Font("SansSerif", Font.BOLD, 30), gold);
            drawCenteredString(g2, "All 20 Heavenly Realms Conquered", 205, new Font("SansSerif", Font.BOLD, 16), blue);
            drawCenteredString(g2, String.format("FINAL FAITH SCORE: %d", engine.score), 260, new Font("Monospaced", Font.BOLD, 22), dark);
            drawCenteredString(g2, "PRESS SPACE TO PLAY AGAIN", 330, new Font("SansSerif", Font.BOLD, 18), gold);
        }
    }
}
