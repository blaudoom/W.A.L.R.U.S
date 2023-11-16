<template>
  <div class="dashboard">
    <h2 v-if="project && project.name">Project: {{ project.name }}</h2>

    <div v-if="project && project.targets" class="pt-6 grid grid-cols-2 gap-6">
      <va-card class="markup-tables mb-8">
        <va-card-title> Nmap Scans for project </va-card-title>

        <va-card-content>
          <table class="va-table w-full">
            <thead>
              <tr>
                <th>ID</th>
                <th>Status</th>
                <th>Time</th>
                <th>Imported</th>
              </tr>
            </thead>

            <tbody>
              <tr v-for="scan in project.nmapScans" :key="scan.id">
                <router-link
                  :to="{
                    name: 'scanDetails',
                    params: {
                      id: scan.id,
                    },
                  }"
                >
                  <td>{{ scan.id }}</td>
                </router-link>
                <td><va-badge :text="scan.status" :color="getStatusColor(scan.status)"></va-badge></td>
                <td>{{ new Date(scan.startTime * 1000) }}</td>
                <td><va-badge v-if="scan.imported" :text="'Imported'" :color="'#f5dd05'"></va-badge></td>
              </tr>
            </tbody>
          </table>
        </va-card-content>
      </va-card>
      <va-card class="markup-tables mb-8">
        <va-card-title>Targets in project</va-card-title>
        <va-card-content>
          <table class="va-table w-full">
            <thead>
              <tr>
                <th>IP-Address</th>
                <th>Hostname</th>
              </tr>
            </thead>

            <tbody>
              <tr v-for="target in project.targets" :key="target.id">
                <td>
                  <router-link
                    :to="{
                      name: 'target',
                      params: {
                        id: target.id,
                      },
                    }"
                    >{{ target.ipAddress }}
                  </router-link>
                </td>
                <td>{{ target.hostname }}</td>
              </tr>
            </tbody>
          </table>
        </va-card-content>
      </va-card>
    </div>

    <div class="flex justify-center mt-2">
      <va-card>
        <va-card-content>
          <va-input v-model="scan.target" :label="'Hostnames'" type="text"></va-input>
          <br />
          <br />
          <va-button :disabled="disabled" @click="runDefaultNmapScan">Run Quick scan!</va-button>
          <va-alert v-model="success" color="success" closeable class="mb-6">
            <template #close> close </template>
            Scan started! Wait {{ countDown / 1000 }} s before starting a new one.
          </va-alert>
        </va-card-content>
      </va-card>
    </div>
  </div>
</template>

<script setup lang="ts">
  import { ref } from 'vue'
  import { useColors } from 'vuestic-ui'

  const project = ref(null)

  const { colors } = useColors()

  const scan = ref({
    target: '',
    defaultScan: true,
  })

  const countDown = ref(0)
  const disabled = ref(false)
  const success = ref(false)
  const response = ref(null)

  fetch('http://localhost:9090/api/project/active')
    .then((response) => response.json())
    .then((data) => (project.value = data))

  function getStatusColor(status: string) {
    if (status === 'RUNNING') {
      return '#f5dd05'
    }
    else if (status === 'DONE') {
      return '#32a852'
    }
    else if (status === 'FAILED') {
      return '#cf311f'
    }
    else if (status === 'PARSING') {
      return '#f5dd05'
    }
  }
  function runDefaultNmapScan() {
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
  function countDownTimer() {
    setTimeout(() => {
      disabled.value = false
      success.value = false
    }, 5000)
  }
</script>

<style lang="scss">
  .dashboard {
    .va-card {
      margin-bottom: 0 !important;
      &__title {
        display: flex;
        justify-content: space-between;
      }
    }
  }
</style>
