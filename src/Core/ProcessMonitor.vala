using Gee;
using GTop;

namespace SystemMonitor.Core { 

    public class ProcessInfo {
        public int pid { get; set; }
        public string name { get; set; }
        public string user { get; set; }
        
        public uint64 cpu_total { get; set; }
        public uint64 cpu_time { get; set; }
    }

    public class ProcessMonitor {
        public static HashMap<int, ProcessInfo> list_processes(HashMap<int, ProcessInfo> processes) {
            GTop.ProcList proc_list;
            try {
                var pids = GTop.get_proclist(out proc_list, GLIBTOP_KERN_PROC_ALL, GLIBTOP_KERN_PROC_ALL);

                // Add or update existing processes
                for(var i = 0; i < proc_list.number; i++) {
                    var proc_name = get_proc_name(pids[i]);
                    var proc_user = get_proc_user(pids[i]);

                    if (proc_name == null || proc_user == null)
                        continue;

                    var process = new ProcessInfo();
                    process.pid = pids[i];
                    process.name = proc_name;
                    process.user = proc_user;

                    if (processes.has_key(pids[i]))
                        processes.unset(pids[i]);

                    processes.set(pids[i], process);
                }

                // Remove old processes
                var toRemove = new ArrayList<int>();
                foreach (var pid in processes.keys) {
                    var exists = false; 
                    for (var i = 0; i < proc_list.number; i++) {
                        if (pid == pids[i]) {
                            exists = true;
                            break;
                        }
                    }

                    if (!exists) {
                        toRemove.add(pid);
                    }
                }

                foreach(var pid in toRemove) {
                    processes.unset(pid);
                }
            } catch (Error e) {
                stdout.printf("Error: %s\n", e.message);
            }

            return processes;
        }

        private static string? get_proc_name(int pid) {
            GTop.ProcArgs proc_args;
            var proc_args_str = GTop.get_proc_args(out proc_args, pid, 128);

            if (proc_args_str.length > 0) {
                proc_args_str = Path.get_basename(proc_args_str);
                proc_args_str = proc_args_str.split(" ")[0];

                return proc_args_str;
            }

            return null;
        }

        private static string? get_proc_user(int pid) {
            GTop.ProcUid proc_uid;
            GTop.get_proc_uid(out proc_uid, pid);

            unowned Posix.Passwd? user = Posix.getpwuid(proc_uid.uid);

            if (user == null)
                return null;

            return user.pw_name;
        }

        private static int get_proc_cpu(int pid) {
            GTop.ProcTime proc_time;
            GTop.get_proc_time(out proc_time, pid);

            var total_time = proc_time.utime + proc_time.stime;

            return 0;
        }
    }
}