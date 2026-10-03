/* main.c - Native Linux & Steam Entry Point for Heaven Chrome */
#include <SDL2/SDL.h>
#include <stdio.h>
#include <stdbool.h>
#include "game.h"
#include "render.h"
#include "audio.h"

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;

#ifdef _WIN32
    printf("=========================================\n");
    printf(" Heaven Chrome - Windows 11 & Steam Build\n");
    printf(" by popa bogdan\n");
    printf("=========================================\n");
#else
    printf("=========================================\n");
    printf(" Heaven Chrome - Native Linux & Steam Build\n");
    printf(" by popa bogdan\n");
    printf("=========================================\n");
#endif

    /* Initialize SDL2 */
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_GAMECONTROLLER) != 0) {
        fprintf(stderr, "Failed to initialize SDL2: %s\n", SDL_GetError());
        return 1;
    }

    /* Create Game Window */
    SDL_Window *window = SDL_CreateWindow(
        "Heaven Chrome - A Divine Time-Bending Journey",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        1024,
        768,
        SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE
    );

    if (!window) {
        fprintf(stderr, "Failed to create SDL2 window: %s\n", SDL_GetError());
        SDL_Quit();
        return 1;
    }

    /* Create Hardware Accelerated Renderer */
    SDL_Renderer *renderer = SDL_CreateRenderer(
        window,
        -1,
        SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC
    );

    if (!renderer) {
        fprintf(stderr, "Hardware acceleration unavailable, falling back to software: %s\n", SDL_GetError());
        renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_SOFTWARE);
        if (!renderer) {
            fprintf(stderr, "Failed to create SDL2 renderer: %s\n", SDL_GetError());
            SDL_DestroyWindow(window);
            SDL_Quit();
            return 1;
        }
    }

    /* Set 800x600 logical resolution with automatic aspect-ratio preservation */
    SDL_RenderSetLogicalSize(renderer, SCREEN_W, SCREEN_H);

    /* Open Game Controller (e.g. Steam Deck controls or Xbox/PlayStation pad) */
    SDL_GameController *controller = NULL;
    for (int i = 0; i < SDL_NumJoysticks(); ++i) {
        if (SDL_IsGameController(i)) {
            controller = SDL_GameControllerOpen(i);
            if (controller) {
                printf("Connected Game Controller: %s\n", SDL_GameControllerName(controller));
                break;
            }
        }
    }

    /* Initialize subsystems */
    audio_init();
    render_init(renderer);
    game_init();

    bool running = true;
    bool fullscreen = false;
    Uint32 prev_time = SDL_GetTicks();

    /* Keyboard / input state */
    bool key_up = false, key_down = false, key_left = false, key_right = false;
    bool key_slow = false;

    while (running) {
        SDL_Event ev;
        while (SDL_PollEvent(&ev)) {
            if (ev.type == SDL_QUIT) {
                running = false;
            }
            /* Controller connect / disconnect */
            else if (ev.type == SDL_CONTROLLERDEVICEADDED) {
                if (!controller) {
                    controller = SDL_GameControllerOpen(ev.cdevice.which);
                    if (controller) {
                        printf("Game Controller connected: %s\n", SDL_GameControllerName(controller));
                    }
                }
            }
            else if (ev.type == SDL_CONTROLLERDEVICEREMOVED) {
                if (controller && ev.cdevice.which == (Sint32)SDL_JoystickInstanceID(SDL_GameControllerGetJoystick(controller))) {
                    SDL_GameControllerClose(controller);
                    controller = NULL;
                    printf("Game Controller disconnected\n");
                }
            }
            /* Keyboard inputs */
            else if (ev.type == SDL_KEYDOWN) {
                SDL_Keycode sym = ev.key.keysym.sym;
                if (sym == SDLK_w || sym == SDLK_UP || sym == SDLK_q) key_up = true;
                if (sym == SDLK_s || sym == SDLK_DOWN || sym == SDLK_a) key_down = true;
                if (sym == SDLK_a || sym == SDLK_LEFT || sym == SDLK_o) key_left = true;
                if (sym == SDLK_d || sym == SDLK_RIGHT || sym == SDLK_p) key_right = true;
                if (sym == SDLK_SPACE) key_slow = true;

                if (sym == SDLK_SPACE || sym == SDLK_RETURN) {
                    game_start_or_respawn();
                }
                if (sym == SDLK_p || sym == SDLK_ESCAPE) {
                    game_toggle_pause();
                }
                if (sym == SDLK_m) {
                    audio_toggle_mute();
                }
                /* Fullscreen toggle (F11 or Alt+Enter) */
                if (sym == SDLK_F11 || (sym == SDLK_RETURN && (ev.key.keysym.mod & KMOD_ALT))) {
                    fullscreen = !fullscreen;
                    SDL_SetWindowFullscreen(window, fullscreen ? SDL_WINDOW_FULLSCREEN_DESKTOP : 0);
                }
            }
            else if (ev.type == SDL_KEYUP) {
                SDL_Keycode sym = ev.key.keysym.sym;
                if (sym == SDLK_w || sym == SDLK_UP || sym == SDLK_q) key_up = false;
                if (sym == SDLK_s || sym == SDLK_DOWN || sym == SDLK_a) key_down = false;
                if (sym == SDLK_a || sym == SDLK_LEFT || sym == SDLK_o) key_left = false;
                if (sym == SDLK_d || sym == SDLK_RIGHT || sym == SDLK_p) key_right = false;
                if (sym == SDLK_SPACE) key_slow = false;
            }
            /* Gamepad / Steam Deck button inputs */
            else if (ev.type == SDL_CONTROLLERBUTTONDOWN) {
                Uint8 btn = ev.cbutton.button;
                if (btn == SDL_CONTROLLER_BUTTON_DPAD_UP) key_up = true;
                if (btn == SDL_CONTROLLER_BUTTON_DPAD_DOWN) key_down = true;
                if (btn == SDL_CONTROLLER_BUTTON_DPAD_LEFT) key_left = true;
                if (btn == SDL_CONTROLLER_BUTTON_DPAD_RIGHT) key_right = true;
                if (btn == SDL_CONTROLLER_BUTTON_A || btn == SDL_CONTROLLER_BUTTON_RIGHTSHOULDER) {
                    key_slow = true;
                    game_start_or_respawn();
                }
                if (btn == SDL_CONTROLLER_BUTTON_START || btn == SDL_CONTROLLER_BUTTON_BACK) {
                    game_toggle_pause();
                }
                if (btn == SDL_CONTROLLER_BUTTON_Y) {
                    audio_toggle_mute();
                }
            }
            else if (ev.type == SDL_CONTROLLERBUTTONUP) {
                Uint8 btn = ev.cbutton.button;
                if (btn == SDL_CONTROLLER_BUTTON_DPAD_UP) key_up = false;
                if (btn == SDL_CONTROLLER_BUTTON_DPAD_DOWN) key_down = false;
                if (btn == SDL_CONTROLLER_BUTTON_DPAD_LEFT) key_left = false;
                if (btn == SDL_CONTROLLER_BUTTON_DPAD_RIGHT) key_right = false;
                if (btn == SDL_CONTROLLER_BUTTON_A || btn == SDL_CONTROLLER_BUTTON_RIGHTSHOULDER) key_slow = false;
            }
            /* Gamepad Analog Stick inputs */
            else if (ev.type == SDL_CONTROLLERAXISMOTION) {
                if (ev.caxis.axis == SDL_CONTROLLER_AXIS_LEFTX) {
                    if (ev.caxis.value < -12000) { key_left = true; key_right = false; }
                    else if (ev.caxis.value > 12000) { key_right = true; key_left = false; }
                    else { key_left = false; key_right = false; }
                }
                if (ev.caxis.axis == SDL_CONTROLLER_AXIS_LEFTY) {
                    if (ev.caxis.value < -12000) { key_up = true; key_down = false; }
                    else if (ev.caxis.value > 12000) { key_down = true; key_up = false; }
                    else { key_up = false; key_down = false; }
                }
                if (ev.caxis.axis == SDL_CONTROLLER_AXIS_TRIGGERRIGHT) {
                    key_slow = (ev.caxis.value > 8000);
                }
            }
        }

        /* Direction vector */
        int dx = 0, dy = 0;
        if (key_up) dy -= 1;
        if (key_down) dy += 1;
        if (key_left) dx -= 1;
        if (key_right) dx += 1;

        game_handle_move(dx, dy);
        game_set_time_slow(key_slow);

        /* Frame timing */
        Uint32 now = SDL_GetTicks();
        float dt = (now - prev_time) / 1000.0f;
        prev_time = now;
        if (dt > 0.05f) dt = 0.05f; /* Cap delta time */

        /* Time slow modifier */
        float sim_dt = dt * (g_game.is_slow ? 0.38f : 1.0f);

        game_update(sim_dt);
        render_frame(renderer);

        /* Target ~60 FPS */
        Uint32 frame_elapsed = SDL_GetTicks() - now;
        if (frame_elapsed < 16) {
            SDL_Delay(16 - frame_elapsed);
        }
    }

    /* Cleanup */
    if (controller) SDL_GameControllerClose(controller);
    audio_shutdown();
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}
