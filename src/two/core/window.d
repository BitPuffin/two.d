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
}
