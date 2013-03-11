module two.core.window;

import std.exception: enforce;
import allegro5.display;

class Window {
    private:
        ALLEGRO_DISPLAY* window;

    public:
        this(int width, int height) {
            window = al_create_display(width, height);
            enforce(window, "Failed to create display");
        }

    @property int width() {
        return al_get_display_width(window);
    }

    @property int height() {
        return al_get_display_height(window);
    }

    void setTitle(string title) {
        al_set_window_title(window, title.idup.ptr);
    }

    void setVSync(bool sync) {
        
    }
}
