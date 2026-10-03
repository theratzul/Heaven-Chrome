/* render.h - SDL2 Graphics, Tilemap & UI Renderer */
#ifndef RENDER_H
#define RENDER_H

#include <SDL2/SDL.h>

void render_init(SDL_Renderer *renderer);
void render_frame(SDL_Renderer *renderer);

/* Built-in font rendering utility */
void render_draw_text(SDL_Renderer *renderer, int x, int y, const char *text, SDL_Color color, int scale);
void render_draw_text_centered(SDL_Renderer *renderer, int y, const char *text, SDL_Color color, int scale);

#endif /* RENDER_H */
