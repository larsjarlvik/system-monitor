namespace SystemMonitor.Widgets { 
    public class Sidebar : Gtk.ScrolledWindow {
        private Gtk.ListBox list_box;

        public Sidebar() {
            build_ui();
        }

        private void build_ui() {
            this.hscrollbar_policy = Gtk.PolicyType.NEVER;
            this.vscrollbar_policy = Gtk.PolicyType.AUTOMATIC;
            this.set_size_request(200, -1);
                
            list_box = new Gtk.ListBox ();
    
            this.add(list_box);
        }

        public void add_sidebar_entry(SidebarEntry sidebar_entry) {
            list_box.add(sidebar_entry);
    
            if (list_box.get_children().length() == 1) {
                list_box.select_row(sidebar_entry);
            }
        }
    }
}