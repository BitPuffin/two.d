module two.core.window;

import std.exception: enforce;
import allegro5.display;

// The currently active window in the allegro library
private ALLEGRO_DISPLAY* current_window;

class Window {
    private:
        ALLEGRO_DISPLAY* window;

    public:
        this(int width, int height, bool vsync=false) {
            // Suggest that the next created window will use vsync
            if (vsync) {
                // Suggest since enforcing it would stop window creation, behaviour might change in the future
                al_set_new_display_option(ALLEGRO_DISPLAY_OPTIONS.ALLEGRO_VSYNC, 1, ALLEGRO_SUGGEST);
            }

            // Create window and throw exception if window is null
            window = al_create_display(width, height);
            enforce(window, "Failed to create display");
            current_window = window;

            // Reset to default after creation
            if (vsync) {
                al_set_new_display_option(ALLEGRO_DISPLAY_OPTIONS.ALLEGRO_VSYNC, 0, ALLEGRO_SUGGEST);
            }
        }
    void setTitle(string title) {
        al_set_window_title(window, title.idup.ptr);
    }

    @property int width() {
        return al_get_display_width(window);
    }
    @property int height() {
        return al_get_display_height(window);
    }
    unittest { auto w = new Window(50, 70); assert(w.width == 50 && w.height == 70, "window resolution properties are broken!"); }

    void destroy() {
        al_destroy_display(window);
    }

    void flip() {
        if (window != current_window) {
            al_set_target_backbuffer(window);
            current_window = window;
        }
        al_flip_display();
    }
}
