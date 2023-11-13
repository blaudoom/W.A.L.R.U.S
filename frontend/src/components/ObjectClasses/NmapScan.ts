export interface NmapScanSpec {
  defaultScriptScan?: boolean
  manualOverride?: boolean
  defaultScan?: boolean
  assumeUp?: boolean
  versionDetection?: boolean
  manualCommand?: string
  target?: string
  verbosity?: any
  scanType?: any
  portRange?: string
  osDetection?: boolean
}
