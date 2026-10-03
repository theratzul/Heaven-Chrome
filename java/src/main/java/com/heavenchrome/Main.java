package com.heavenchrome;

import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;

public class Main {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            try {
                UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
            } catch (Exception ignored) {
            }

            JFrame frame = new JFrame("Heaven Chrome - A Divine Time-Bending Journey");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setResizable(false);

            GameEngine engine = new GameEngine();
            GamePanel panel = new GamePanel(engine);
            frame.setContentPane(panel);

            // Create Celestial Golden Halo Icon
            BufferedImage icon = new BufferedImage(64, 64, BufferedImage.TYPE_INT_ARGB);
            Graphics2D ig = icon.createGraphics();
            ig.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            // Heavenly Blue Background
            ig.setColor(new Color(19, 78, 124));
            ig.fillRoundRect(0, 0, 64, 64, 16, 16);
            // Golden Halo
            ig.setColor(new Color(255, 215, 0));
            ig.setStroke(new BasicStroke(4));
            ig.drawOval(12, 10, 40, 16);
            // Pure White Spirit Orb
            ig.setColor(Color.WHITE);
            ig.fillOval(20, 24, 24, 24);
            ig.dispose();
            frame.setIconImage(icon);

            frame.pack();
            frame.setLocationRelativeTo(null);
            frame.setVisible(true);

            panel.requestFocusInWindow();
        });
    }
}
