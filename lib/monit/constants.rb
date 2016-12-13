# Constants from monit sources:
# - monit.h
# - event.h
module Monit
  MONITOR_NOT = 0
  MONITOR_YES = 1
  MONITOR_INIT = 2
  MONITOR_WAITING = 4

  MONITORMODE_ACTIVE = 0
  MONITORMODE_PASSIVE = 1
  MONITORMODE_MANUAL = 2

  PENDINGACTION_IGNORE = 0
  PENDINGACTION_ALERT = 1
  PENDINGACTION_RESTART = 2
  PENDINGACTION_STOP = 3
  PENDINGACTION_EXEC = 4
  PENDINGACTION_UNMONITOR = 5
  PENDINGACTION_START = 6
  PENDINGACTION_MONITOR = 7

  STATE_SUCCEEDED = 0
  STATE_FAILED = 1
  STATE_CHANGED = 2
  STATE_CHANGEDNOT = 3
  STATE_INIT = 4

  SERVICE_TYPE_FILESYSTEM = 0
  SERVICE_TYPE_DIRECTORY = 1
  SERVICE_TYPE_FILE = 2
  SERVICE_TYPE_PROCESS = 3
  SERVICE_TYPE_HOST = 4
  SERVICE_TYPE_SYSTEM = 5
  SERVICE_TYPE_FIFO = 6
  SERVICE_TYPE_PROGRAM = 7

  STATUS_CHECKSUM = 0x1
  STATUS_RESOURCE = 0x2
  STATUS_TIMEOUT = 0x4
  STATUS_TIMESTAMP = 0x8
  STATUS_SIZE = 0x10
  STATUS_CONNECTION = 0x20
  STATUS_PERMISSION = 0x40
  STATUS_UID = 0x80
  STATUS_GID = 0x100
  STATUS_NONEXIST = 0x200
  STATUS_INVALID = 0x400
  STATUS_DATA = 0x800
  STATUS_EXEC = 0x1000
  STATUS_FSFLAG = 0x2000
  STATUS_ICMP = 0x4000
  STATUS_CONTENT = 0x8000
  STATUS_INSTANCE = 0x10000
  STATUS_ACTION = 0x20000
  STATUS_PID = 0x40000
  STATUS_PPID = 0x80000
  STATUS_HEARTBEAT = 0x100000
  STATUS_STATUS = 0x200000
  STATUS_UPTIME = 0x40000
end
