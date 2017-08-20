namespace SystemMonitor.Widgets { 
    public class SidebarEntry : Gtk.ListBoxRow {
        public string id { get; construct; }
        public string title { get; construct; }
        public string subtitle { get; construct; }
        public string icon { get; construct; }

        private Gtk.Grid grid;

        private Gtk.Overlay overlay_icon;
        private Gtk.Image primary_icon;

        private Gtk.Label title_label;
        private Gtk.Label subtitle_label;

        public SidebarEntry(string id, string title, string subtitle, string icon) {
            Object(id: id, title: title, subtitle: subtitle, icon: icon);
            build_ui();
        }

        public void update_subtitle(string content) {
            subtitle_label.label = content;
        }

        private void build_ui () {
            grid = new Gtk.Grid ();
            grid.margin = 6;
            grid.column_spacing = 3;
    
            overlay_icon = new Gtk.Overlay();
    
            primary_icon = new Gtk.Image.from_icon_name(icon, Gtk.IconSize.DND);
            primary_icon.margin_end = 3;
    
            overlay_icon.add(primary_icon);
    
            title_label = new Gtk.Label(title);
            title_label.get_style_context().add_class(Granite.StyleClass.H3_TEXT);
            title_label.halign = Gtk.Align.START;
            title_label.ellipsize = Pango.EllipsizeMode.END;
    
            subtitle_label = new Gtk.Label(subtitle);
            subtitle_label.halign = Gtk.Align.START;
    
            grid.attach(overlay_icon, 0, 0, 1, 2);
            grid.attach(title_label, 1, 0, 1, 1);
            grid.attach(subtitle_label, 1, 1, 1, 1);
    
            this.add(grid);
        }
    }
}