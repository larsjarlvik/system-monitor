using GTop;

int main(string[] args) {
    Gtk.init(ref args);

    GTop.Cpu cpu;
    GTop.get_cpu (out cpu);
    stdout.printf ("CPU\n\nTotal:\t%ld\nUser:\t%ld\nNice:\t%ld\nSys:\t%ld\nIdle:\t%ld\nFreq:\t%ld\n",
        (long)cpu.total, (long)cpu.user, (long)cpu.nice, (long)cpu.sys, (long)cpu.idle, (long)cpu.frequency);

    var window = new Gtk.Window();
    window.title = "Hello World!";
    window.set_border_width(12);
    window.set_position(Gtk.WindowPosition.CENTER);
    window.set_default_size(350, 70);
    window.destroy.connect(Gtk.main_quit);


    window.show_all();

    Gtk.main();
    return 0;
}
