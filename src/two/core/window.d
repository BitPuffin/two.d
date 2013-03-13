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
        /// Not used very often, only if you want to manually construct a window using Allegro's API and then put it in an OO wrapper. Might be a good idea to set your ALLEGRO_DISPLAY pointer to null after calling constructor
        this(ALLEGRO_DISPLAY* w) {
            window = w;
        }
        ~this() {
            al_destroy_display(window);
        }

        /// Sets the passed string as the title of the game window
        void setTitle(string title) {
            al_set_window_title(window, title.idup.ptr);
        }

        /// Gets the current width of the game window
        /// See_Also: resize, height
        @property int width() {
            return al_get_display_width(window);
        }
        /// Gets the current hegiht of the game window
        /// See_Also: resize, width
        @property int height() {
            return al_get_display_height(window);
        }
        unittest { auto w = new Window(50, 70); assert(w.width == 50 && w.height == 70, "window resolution properties are broken!"); }

        /// Destroys the game window
        void destroy() {
            al_destroy_display(window);
        }

        /** Flips the buffers of the display object
          *
          * When draw operations are called on a window
          * they don't appear on the screen until the buffers
          * are flipped since all draw operations happen on the
          * back buffer by default.
          */
        void flip() {
            if (!isCurrent()) {
                al_set_target_backbuffer(window);
                current_window = window;
            }
            al_flip_display();
        }
        
        /** Rezises the window to the specified dimensions
          *
          * Returns: true, if the resize is a success, false if not.
          */
        bool resize(int width, int height) {
            return al_resize_display(window, width, height);
        }

        /** Gets the raw pointer to the ALLEGRO_DISPLAY object.
         *
         *  Not used very often, only if you want to complete actions on the raw display object using the allegro API.
         *  Might be a good idea to set the pointer to null after you are done. Just for the sake of GC.
         */
        ALLEGRO_DISPLAY* getAllegroDisplayPointer() {
            return window;
        }

    private:
        bool isCurrent() {
            return current_window == window;
        }
}
