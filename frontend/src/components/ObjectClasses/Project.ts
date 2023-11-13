export interface Project {
  id: number
  name: string
  description?: any
  info?: any
  nmapInitialized: boolean
  nmapScans: NmapScan[]
  targets: Target[]
}
export interface Service {
  id: number
  name: string
  state: string
  port: number
  servicefp?: any
  version?: any
  product?: any
  cpe?: any
  protocol: string
  scriptResults: any[]
}

export interface Host {
  id: number
  ipAddress: string
  hostname: string
  info?: any
  description?: any
  services: Service[]
  state: string
  hostnames: Hostname[]
}
export interface NmapScan {
  id: number
  startTime: number
  nmapHosts: Host[]
  status: string
}
export interface TargetService {
  id: number
  name: string
  state: string
  port: number
  version?: any
  product?: any
  cpe?: any
  protocol: string
  servicefp?: any
  serviceNotes: any[]
  targetServiceIterations: TargetService[]
}
export interface Hostname {
  id: number
  hostname: string
  type: string
}
export interface Target {
  id: number
  ipAddress: string
  hostname: string
  info?: any
  description?: any
  services: TargetService[]
  state: string
  hostnames: Hostname[]

  seenOnScanId: number[]
}
