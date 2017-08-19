namespace SystemMonitor.Widgets { 
    public class ProcessPage : Gtk.Grid {
        private SidebarEntry sidebar_entry;
        private Gtk.ListStore process_store;
        private Gtk.TreeView process_view;

        public ProcessPage() {
            build_ui();
        }

        public SidebarEntry get_sidebar_entry() {
            if (sidebar_entry == null) {
                sidebar_entry = new SidebarEntry("proc", "Processes", "121 running", "computer");
            }
    
            return sidebar_entry;
        }

        private void build_ui() {
            this.process_store = new Gtk.ListStore(3, typeof(string), typeof(string), typeof(int));

            Gtk.TreeIter iter;
            this.process_store.append(out iter);
            this.process_store.set(iter, 0, "System Monitor", 1, "lasse", 2, 13);

            this.process_view = new Gtk.TreeView.with_model(process_store);
            this.process_view.set_headers_clickable(true);
            this.process_view.expand = true;

            var cell = new Gtk.CellRendererText ();
            process_view.insert_column_with_attributes(-1, "Name", cell, "text", 0);
            process_view.insert_column_with_attributes(-1, "User", cell, "text", 1);
            process_view.insert_column_with_attributes(-1, "CPU", cell, "text", 2);

            var main_container = new Gtk.Paned(Gtk.Orientation.VERTICAL);
            main_container.pack1(process_view, true, true);

            this.column_spacing = 12;
            this.row_spacing = 12;
            this.add(main_container);
        }
    }
}