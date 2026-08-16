import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "barti.system-stats"

  property string cpu: "--"
  property string memory: "--"
  property string disk: "--"
  property string gpu: "--"

  implicitWidth: widgets.implicitWidth
  implicitHeight: widgets.implicitHeight

  function refresh() {
    if (!statsProcess.running) statsProcess.running = true
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  Process {
    id: statsProcess
    command: ["bash", "-c", "cpu=$(LC_ALL=C top -bn1 | awk '/^%Cpu/ { printf \"%.0f%%\", 100 - $8 }'); mem=$(free | awk '/^Mem:/ { printf \"%d%%\", $3 * 100 / $2 }'); disk=$(df -h / | awk 'NR==2 { print $4 }'); gpu=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | awk '$1 ~ /^[0-9]+$/ { if (!found || $1 > max) max=$1; found=1 } END { if (found) print max }'); if [ -z \"$gpu\" ]; then gpu=$(for p in /sys/class/drm/card*/device/gpu_busy_percent; do [ -r \"$p\" ] && cat \"$p\" && break; done); fi; if [ -n \"$gpu\" ]; then gpu=\"${gpu}%\"; else gpu=N/A; fi; printf '%s|%s|%s|%s\\n' \"$cpu\" \"$mem\" \"$disk\" \"$gpu\""]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        const values = text.trim().split("|")
        if (values.length !== 4) return
        root.cpu = values[0]
        root.memory = values[1]
        root.disk = values[2]
        root.gpu = values[3]
      }
    }
  }

  Row {
    id: widgets
    spacing: 8

    Row {
      BarIconButton {
        bar: root.bar
        text: "󰍛"
        slotSize: 22
        tooltipText: "CPU: " + root.cpu
        onPressed: root.bar.run("uwsm app -- xdg-terminal-exec -e btop")
      }
      Text {
        anchors.verticalCenter: parent.verticalCenter
        text: root.cpu
        color: root.bar ? root.bar.foreground : "white"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: Style.font.caption
      }
    }

    Row {
      BarIconButton {
        bar: root.bar
        text: "󰘚"
        slotSize: 22
        tooltipText: "Memory: " + root.memory
        onPressed: root.bar.run("uwsm app -- xdg-terminal-exec -e btop")
      }
      Text {
        anchors.verticalCenter: parent.verticalCenter
        text: root.memory
        color: root.bar ? root.bar.foreground : "white"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: Style.font.caption
      }
    }

    Row {
      BarIconButton {
        bar: root.bar
        text: "󰋊"
        slotSize: 22
        tooltipText: "Disk free: " + root.disk
        onPressed: root.bar.run("uwsm app -- xdg-terminal-exec -e btop")
      }
      Text {
        anchors.verticalCenter: parent.verticalCenter
        text: root.disk
        color: root.bar ? root.bar.foreground : "white"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: Style.font.caption
      }
    }

    Row {
      BarIconButton {
        bar: root.bar
        text: "󰢮"
        slotSize: 22
        tooltipText: "GPU: " + root.gpu
        onPressed: root.bar.run("uwsm app -- xdg-terminal-exec -e btop")
      }
      Text {
        anchors.verticalCenter: parent.verticalCenter
        text: root.gpu
        color: root.bar ? root.bar.foreground : "white"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: Style.font.caption
      }
    }

    Item {
      width: 8
      height: 1
    }
  }
}
