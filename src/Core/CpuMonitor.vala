using GTop;

namespace SystemMonitor.Core { 
    public class CpuMonitor {
        public static void print_cpu() {
            GTop.Cpu cpu;
            GTop.get_cpu (out cpu);
            stdout.printf ("CPU\n\nTotal:\t%ld\nUser:\t%ld\nNice:\t%ld\nSys:\t%ld\nIdle:\t%ld\nFreq:\t%ld\n",
                (long)cpu.total, (long)cpu.user, (long)cpu.nice, (long)cpu.sys, (long)cpu.idle, (long)cpu.frequency);
        }
    }
}