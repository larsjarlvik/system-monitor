using GTop;
using SystemMonitor.Core;
using SystemMonitor.Widgets;

namespace SystemMonitor { 
    public class Main : Granite.Application {
        construct {
            application_id = "com.github.larsjarlvik.system-monitor";
            flags = ApplicationFlags.FLAGS_NONE;

            program_name = "System Monitor";
            build_version = "0.1";
            app_icon = "application-default-icon";
        }

        public override void activate() {
            var window = new Gtk.Window();
            var sidebar = new Widgets.Sidebar();

            var process_page = new ProcessPage();

            sidebar.add_sidebar_entry(process_page.get_sidebar_entry());

            window.set_default_size(900, 600);
            window.set_size_request(750, 500);
            window.set_position(Gtk.WindowPosition.CENTER);
            window.title = "System Monitor";

            var main_container = new Gtk.Paned(Gtk.Orientation.HORIZONTAL);
            main_container.pack1(sidebar, false, false);
            main_container.pack2(process_page, true, false);

            window.add(main_container);
            window.show_all();

            add_window(window);
        }

        public static int main(string[] args) {
            CpuMonitor.print_cpu();

            var application = new Main();
            return application.run(args);
        }
    }
}
