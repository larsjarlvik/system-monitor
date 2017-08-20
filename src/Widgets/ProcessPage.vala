using Gee;
using SystemMonitor.Core;

namespace SystemMonitor.Widgets { 
    public class ProcessPage : Gtk.Grid {
        private SidebarEntry sidebar_entry;
        private Gtk.ListStore process_store;
        private Gtk.TreeView process_view;
        private HashMap<int, Gtk.TreeIter?> process_iters;

        private HashMap<int, ProcessInfo> processes;

        public ProcessPage() {
            processes = new HashMap<int, ProcessInfo>();
            process_iters = new HashMap<int, Gtk.TreeIter?>();

            build_ui();

            Timeout.add_full(Priority.DEFAULT, 1000, update_process_view);
        }

        public SidebarEntry get_sidebar_entry() {
            if (sidebar_entry == null) {
                sidebar_entry = new SidebarEntry("proc", "Processes", "Loading...", "computer");
            }
    
            return sidebar_entry;
        }

        private void build_ui() {
            process_store = new Gtk.ListStore(4, typeof(string), typeof(string), typeof(int), typeof(int));

            process_view = new Gtk.TreeView.with_model(process_store);
            process_view.headers_clickable = true;
            process_view.expand = true;

            var cell = new Gtk.CellRendererText ();
            process_view.insert_column_with_attributes(-1, "Name", cell, "text", 0);
            process_view.insert_column_with_attributes(-1, "User", cell, "text", 1);
            process_view.insert_column_with_attributes(-1, "PID", cell, "text", 2);
            process_view.insert_column_with_attributes(-1, "CPU", cell, "text", 3);
            process_view.columns_autosize();
           
            var scroll_container = new Gtk.ScrolledWindow(null, null);
            scroll_container.add(process_view);
            scroll_container.shadow_type = Gtk.ShadowType.OUT;

            var button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
            var kill_button = new Gtk.Button.with_label("End process");
            kill_button.get_style_context().add_class("destructive-action");

            button_box.pack_end(kill_button, false, false, 0);

            this.column_spacing = 12;
            this.row_spacing = 12;
            this.margin = 12;
            this.attach(scroll_container, 0, 0);
            this.attach(button_box, 0, 1);
        }

        private void update_process_list() {
            var model = process_view.get_model();

            // Remove stopped processes
            var toRemove = new ArrayList<int>();
            foreach(var pid in process_iters.keys) {
                if (processes.has_key(pid))
                    continue;

                process_store.remove(process_iters.get(pid));
                toRemove.add(pid);
            }

            foreach(var pid in toRemove) {
                process_iters.unset(pid);
            }
            
            // Add or update processes
            foreach(var process in processes.values) {
                Gtk.TreeIter iter;

                if (process_iters.has_key(process.pid)) {
                    iter = process_iters.get(process.pid);
                    continue;
                }

                process_store.append(out iter);
                process_store.set(iter, 
                    0, process.name, 
                    1, process.user, 
                    2, process.pid, 
                    3, 10);

                process_iters.set(process.pid, iter);
            }
        }

        private bool update_process_view() {
            processes = ProcessMonitor.list_processes(processes);

            foreach (var process in processes.values) {
                update_process_list();
                sidebar_entry.update_subtitle(processes.size.to_string() + " total");
            }

            return true;
        }
    }
}