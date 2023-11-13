<template>
  <div class="form-elements grid grid-cols-12 gap-6">
    <va-card class="col-span-6">
      <va-card-title>Nmap Options Form</va-card-title>
      <va-card-content>
        <form @submit.prevent="runNmapScan">
          <div
            class="form-group va-input-wrapper va-input-wrapper--focused va-input-wrapper--labeled va-input-wrapper--solid va-input mb-4"
          >
            <va-checkbox v-model="scan.defaultScan" :label="'Run default scan!'" />
          </div>
          <div
            v-if="!scan.manualOverride"
            class="form-group va-input-wrapper va-input-wrapper--focused va-input-wrapper--labeled va-input-wrapper--solid va-input mb-4"
          >
            <va-input
              id="target"
              v-model="scan.target"
              type="text"
              :label="'Target Specification:'"
              class="form-control"
              placeholder="Ex: scanme.nmap.org, 192.168.0.1"
            />
          </div>
          <div
            v-if="!scan.manualOverride"
            class="form-group va-input-wrapper va-input-wrapper--focused va-input-wrapper--labeled va-input-wrapper--solid va-input mb-4"
          >
            <va-input
              id="range"
              v-model="scan.portRange"
              type="text"
              :label="'Ports (leave empty for default ports)'"
              class="form-control"
              placeholder="Ex: 1-2000 or 80,443,8080"
            />
            <br />
            <br />
            <va-checkbox v-model="scan.fullScan" :label="'All 65k ports'" />
          </div>
          <div
            v-if="!scan.manualOverride && !scan.defaultScan"
            class="form-group va-input-wrapper va-input-wrapper--focused va-input-wrapper--labeled va-input-wrapper--solid va-input mb-4"
          >
            <va-checkbox v-model="scan.assumeUp" :label="'Do not ping. Assume up. (-Pn)'" />
          </div>
          <div
            v-if="!scan.manualOverride && !scan.defaultScan"
            class="form-group va-input-wrapper va-input-wrapper--focused va-input-wrapper--labeled va-input-wrapper--solid va-input mb-4"
          >
            <va-input
              id="range"
              v-model="scan.timeTemplate"
              type="number"
              max="5"
              min="0"
              :label="'Time template (0-5)'"
              class="form-control"
            />
          </div>
          <div
            v-if="!scan.manualOverride && !scan.defaultScan"
            class="form-group va-input-wrapper va-input-wrapper--focused va-input-wrapper--labeled va-input-wrapper--solid va-input mb-4"
          >
            <va-select
              id="scanType"
              v-model="scan.scanType"
              :label="'Scan types'"
              class="form-control"
              :options="scanOptions"
              multiple
              text-by="val"
              track-by="id"
            >
            </va-select>
          </div>
          <div
            v-if="!scan.manualOverride && !scan.defaultScan"
            class="form-group va-input-wrapper va-input-wrapper--focused va-input-wrapper--labeled va-input-wrapper--solid va-input mb-4"
          >
            <va-select
              id="verbosity"
              v-model="scan.verbosity"
              :label="'Verbosity'"
              class="form-control"
              track-by="id"
              text-by="val"
              :options="verbosityOptions"
            >
            </va-select>
          </div>

          <div
            v-if="!scan.manualOverride && !scan.defaultScan"
            class="form-group va-input-wrapper va-input-wrapper--focused va-input-wrapper--labeled va-input-wrapper--solid va-input mb-4"
          >
            <va-checkbox v-model="scan.defaultScriptScan" :label="'Use default scripts (-sC)'" />
          </div>
          <div
            v-if="!scan.manualOverride && !scan.defaultScan"
            class="form-group va-input-wrapper va-input-wrapper--focused va-input-wrapper--labeled va-input-wrapper--solid va-input mb-4"
          >
            <va-checkbox v-model="scan.versionDetection" :label="'Version detection (-sV)'" />
          </div>
          <div
            v-if="!scan.manualOverride && !scan.defaultScan"
            class="form-group va-input-wrapper va-input-wrapper--focused va-input-wrapper--labeled va-input-wrapper--solid va-input mb-4"
          >
            <va-checkbox v-model="scan.osDetection" :label="'OS detection (-O) REQUIRES ROOT PRIVILEGES!'" />
          </div>
          <div
            v-if="!scan.defaultScan"
            class="form-group va-input-wrapper va-input-wrapper--focused va-input-wrapper--labeled va-input-wrapper--solid va-input mb-4"
          >
            <va-checkbox
              v-model="scan.manualOverride"
              :label="'Manually give nmap command. (At your own risk. Most likely wont work well)'"
            />
          </div>
          <div
            v-if="scan.manualOverride && !scan.defaultScan"
            class="form-group va-input-wrapper va-input-wrapper--focused va-input-wrapper--labeled va-input-wrapper--solid va-input mb-4"
          >
            <va-input
              id="command"
              v-model="scan.manualCommand"
              type="text"
              :label="'Command'"
              class="form-control"
              placeholder="nmap "
            />
          </div>
          <div
            class="form-group va-input-wrapper va-input-wrapper--focused va-input-wrapper--labeled va-input-wrapper--solid va-input mb-4"
          >
            <va-button type="submit" class="btn btn-primary" :disabled="disabled">Run Nmap Scan</va-button>
            <va-alert v-model="success" color="success" closeable class="mb-6">
              <template #close> close </template>
              Scan started! Wait {{ countDown / 1000 }} s before starting a new one.
            </va-alert>
          </div>
        </form>
        <!--div class="mt-3">
          <h2>Command to Execute:</h2>
          <pre>{{ generateNmapCommand() }}</pre>
        </div-->
      </va-card-content>
    </va-card>
    <va-card class="col-span-5">
      <va-card-content>
        <span v-html="helpTxt" />
      </va-card-content>
    </va-card>
  </div>
</template>
<script setup lang="ts">
  import { ref } from 'vue'
  import { NmapScanSpec } from '../../../components/ObjectClasses/NmapScan'

  const project = ref(null)

  fetch('http://localhost:9090/api/project/active')
    .then((response) => response.json())
    .then((data) => (project.value = data))

  const scanOptions = ref([
    {
      id: 1,
      val: '-sS',
    },
    {
      id: 2,
      val: '-sT',
    },
    {
      id: 3,
      val: '-sW',
    },
    {
      id: 4,
      val: '-sA',
    },
    {
      id: 5,
      val: '-sM',
    },
  ])
  const verbosityOptions = ref([
    {
      id: 1,
      val: '-v',
    },
    {
      id: 2,
      val: '-vv',
    },
    {
      id: 3,
      val: '-vvv',
    },
  ])

  const scan = ref({
    defaultScriptScan: false,
    manualOverride: false,
    manualCommand: 'nmap',
    target: '',
    verbosity: { id: null, value: null },
    scanType: [],
    portRange: '',
    defaultScan: false,
    osDetection: false,
  })

  const response = ref()
  const defaultScanString = ref(null)
  const countDown = ref(0)
  const disabled = ref(false)
  const success = ref(false)

  fetch('http://localhost:9090/api/settings/')
    .then((response) => response.json())
    .then((data) => {
      defaultScanString.value = data
    })

  function runNmapScan() {
    const requestOptions = {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(scan.value),
    }
    fetch('http://localhost:9090/api/nmap/run', requestOptions)
      .then((response) => {
        console.log(response.json())
        success.value = true
        disabled.value = true
        countDown.value = 5000
        countDownTimer()
      })
      .then((data) => {
        response.value = data
      })
  }

  function generateNmapCommand() {
    const verb: string = scan.value.verbosity.val
    const scantypes: string = scan.value.scanType.map((_) => _.val).join(' ')

    const commandParts = [
      'nmap',
      verb,
      scantypes,
      scan.value.defaultScriptScan ? '-sC' : null,
      scan.value.portRange != '' ? '-p' + scan.value.portRange : null,
      scan.value.target,
    ]

    // Add more options to commandParts as needed
    return scan.value.manualOverride ? scan.value.manualCommand : commandParts.join(' ')
  }
  function countDownTimer() {
    setTimeout(() => {
      disabled.value = false
      success.value = false
    }, 5000)
  }

  // Move to database
  const helpTxt =
    '<pre style=\'background-color: white; font-family: monospace !important; padding: 5px; padding-left:10px;\'>Nmap 5.51 ( <a href="http://nmap.org/">http://nmap.org</a> )\n' +
    'Usage: nmap [Scan <b>Type</b>(s)] [Options] {target specification}\n' +
    'TARGET SPECIFICATION:\n' +
    '  Can pass hostnames, IP addresses, networks, etc.\n' +
    '  Ex: scanme.nmap.org, 192.168.0.1; 10.0.0-255.1-254\n' +
    '  -iL &lt;inputfilename&gt;: Input from list of hosts/networks\n' +
    '  -iR &lt;num hosts&gt;: Choose random targets\n' +
    '  --exclude &lt;host1[,host2][,host3],...&gt;: Exclude hosts/networks\n' +
    '  --excludefile &lt;exclude_file&gt;: Exclude list from file\n' +
    'HOST DISCOVERY:\n' +
    '  -sL: List Scan - simply list targets to scan\n' +
    '  -sn: Ping Scan - disable port scan\n' +
    '  -Pn: Treat all hosts as online -- skip host discovery\n' +
    '  -PS/PA/PU/PY[portlist]: TCP SYN/ACK, UDP or SCTP discovery to given ports\n' +
    '  -PE/PP/PM: ICMP echo, timestamp, and netmask request discovery probes\n' +
    '  -PO[protocol list]: IP Protocol Ping\n' +
    '  -n/-R: Never do DNS resolution/Always resolve [default: sometimes]\n' +
    '  --dns-servers &lt;serv1[,serv2],...&gt;: Specify custom DNS servers\n' +
    "  --system-dns: Use OS's DNS resolver\n" +
    '  --traceroute: Trace hop path to each host\n' +
    'SCAN TECHNIQUES:\n' +
    '  -sS/sT/sA/sW/sM: TCP SYN/Connect()/ACK/Window/Maimon scans\n' +
    '  -sU: UDP Scan\n' +
    '  -sN/sF/sX: TCP Null, FIN, and Xmas scans\n' +
    '  --scanflags &lt;flags&gt;: Customize TCP scan flags\n' +
    '  -sI &lt;zombie host[:probeport]&gt;: Idle scan\n' +
    '  -sY/sZ: SCTP INIT/COOKIE-ECHO scans\n' +
    '  -sO: IP protocol scan\n' +
    '  -b &lt;FTP relay host&gt;: FTP bounce scan\n' +
    'PORT SPECIFICATION AND SCAN ORDER:\n' +
    '  -p &lt;port ranges&gt;: Only scan specified ports\n' +
    '    Ex: -p22; -p1-65535; -p U:53,111,137,T:21-25,80,139,8080,S:9\n' +
    '  -F: Fast mode - Scan fewer ports than the default scan\n' +
    "  -r: Scan ports consecutively - don't randomize\n" +
    '  --top-ports &lt;number&gt;: Scan &lt;number&gt; most common ports\n' +
    '  --port-ratio &lt;ratio&gt;: Scan ports more common than &lt;ratio&gt;\n' +
    'SERVICE/VERSION DETECTION:\n' +
    '  -sV: Probe open ports to determine service/version info\n' +
    '  --version-intensity &lt;level&gt;: Set from 0 (light) to 9 (try all probes)\n' +
    '  --version-light: Limit to most likely probes (intensity 2)\n' +
    '  --version-all: Try every single probe (intensity 9)\n' +
    '  --version-trace: Show detailed version scan activity (for debugging)\n' +
    'SCRIPT SCAN:\n' +
    '  -sC: equivalent to --script=default\n' +
    '  --script=&lt;Lua scripts&gt;: &lt;Lua scripts&gt; is a comma separated list of\n' +
    '           directories, script-files or script-categories\n' +
    '  --script-args=&lt;n1=v1,[n2=v2,...]&gt;: provide arguments to scripts\n' +
    '  --script-trace: Show all data sent and received\n' +
    '  --script-updatedb: Update the script database.\n' +
    'OS DETECTION:\n' +
    '  -O: Enable OS detection\n' +
    '  --osscan-limit: Limit OS detection to promising targets\n' +
    '  --osscan-guess: Guess OS more aggressively\n' +
    'TIMING AND PERFORMANCE:\n' +
    "  Options which take &lt;time&gt; are in seconds, or append 'ms' (milliseconds),\n" +
    "  's' (seconds), 'm' (minutes), or 'h' (hours) to the value (e.g. 30m).\n" +
    '  -T&lt;0-5&gt;: Set timing template (higher is faster)\n' +
    '  --min-hostgroup/max-hostgroup &lt;size&gt;: Parallel host scan group sizes\n' +
    '  --min-parallelism/max-parallelism &lt;numprobes&gt;: Probe parallelization\n' +
    '  --min-rtt-timeout/max-rtt-timeout/initial-rtt-timeout &lt;time&gt;: Specifies\n' +
    '      probe round trip time.\n' +
    '  --max-retries &lt;tries&gt;: Caps number of port scan probe retransmissions.\n' +
    '  --host-timeout &lt;time&gt;: Give up on target after this long\n' +
    '  --scan-delay/--max-scan-delay &lt;time&gt;: Adjust delay between probes\n' +
    '  --min-rate &lt;number&gt;: Send packets no slower than &lt;number&gt; per second\n' +
    '  --max-rate &lt;number&gt;: Send packets no faster than &lt;number&gt; per second\n' +
    'FIREWALL/IDS EVASION AND SPOOFING:\n' +
    '  -f; --mtu &lt;val&gt;: fragment packets (optionally w/given MTU)\n' +
    '  -D &lt;decoy1,decoy2[,ME],...&gt;: Cloak a scan with decoys\n' +
    '  -S &lt;IP_Address&gt;: Spoof source address\n' +
    '  -e &lt;iface&gt;: Use specified interface\n' +
    '  -g/--source-port &lt;portnum&gt;: Use given port number\n' +
    '  --data-length &lt;num&gt;: Append random data to sent packets\n' +
    '  --ip-options &lt;options&gt;: Send packets with specified ip options\n' +
    '  --ttl &lt;val&gt;: Set IP time-to-live field\n' +
    '  --spoof-mac &lt;mac address/prefix/vendor name&gt;: Spoof your MAC address\n' +
    '  --badsum: Send packets with a bogus TCP/UDP/SCTP checksum\n' +
    'OUTPUT:\n' +
    '  -oN/-oX/-oS/-oG &lt;file&gt;: Output scan in normal, XML, s|&lt;rIpt kIddi3,\n' +
    '     and Grepable format, respectively, to the given filename.\n' +
    '  -oA &lt;basename&gt;: Output in the three major formats at once\n' +
    '  -v: Increase verbosity level (use -vv or more for greater effect)\n' +
    '  -d: Increase debugging level (use -dd or more for greater effect)\n' +
    '  --reason: Display the reason a port is in a particular state\n' +
    '  --open: Only show open (or possibly open) ports\n' +
    '  --packet-trace: Show all packets sent and received\n' +
    '  --iflist: Print host interfaces and routes (for debugging)\n' +
    '  --log-errors: Log errors/warnings to the normal-format output file\n' +
    '  --append-output: Append to rather than clobber specified output files\n' +
    '  --resume &lt;filename&gt;: Resume an aborted scan\n' +
    '  --stylesheet &lt;path/URL&gt;: XSL stylesheet to transform XML output to HTML\n' +
    '  --webxml: Reference stylesheet from Nmap.Org for more portable XML\n' +
    '  --no-stylesheet: Prevent associating of XSL stylesheet w/XML output\n' +
    'MISC:\n' +
    '  -6: Enable IPv6 scanning\n' +
    '  -A: Enable OS detection, version detection, script scanning, and traceroute\n' +
    '  --datadir &lt;dirname&gt;: Specify custom Nmap data file location\n' +
    '  --send-eth/--send-ip: Send using raw ethernet frames or IP packets\n' +
    '  --privileged: Assume that the user is fully privileged\n' +
    '  --unprivileged: Assume the user lacks raw socket privileges\n' +
    '  -V: Print version number\n' +
    '  -h: Print this help summary page.\n' +
    'EXAMPLES:\n' +
    '  nmap -v -A scanme.nmap.org\n' +
    '  nmap -v -sn 192.168.0.0/16 10.0.0.0/8\n' +
    '  nmap -v -iR 10000 -Pn -p 80\n' +
    'SEE THE MAN PAGE (<a href="http://nmap.org/book/man.html">http://nmap.org/book/man.html</a>) FOR MORE OPTIONS AND EXAMPLES\n' +
    '</font></pre>\n' +
    ''
</script>
