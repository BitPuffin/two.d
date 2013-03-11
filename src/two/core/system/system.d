module two.base.system.system;

private {
    import allegro5.system: al_run_allegro, al_init;
}

public:

alias al_run_allegro runTwo;

static this() {
    al_init();
}

