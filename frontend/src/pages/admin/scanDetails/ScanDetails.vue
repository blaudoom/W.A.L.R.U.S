<template>
  <div class="dashboard">
    <div class="pt-6 grid grid-cols-1 gap-6">
      <va-card class="markup-tables mb-10">
        <va-card-content>
          <div class="container mt-1">
            <h1 class="mb-4">Scan Errors</h1>
            {{ nmapData?.errors }}
          </div>
        </va-card-content>
      </va-card>
      <va-card class="markup-tables mb-10">
        <va-card-content>
          <div>
            <h2>Scan Information</h2>
            <p>Scan ID: {{ nmapData?.id }}</p>
            <p>Start Time: {{ formatDate(nmapData?.startTime) }}</p>
            <p>Status: {{ nmapData?.status }}</p>
            <p>Raw Data:</p>

            <h2>Nmap Hosts</h2>
            <div v-for="nmapHost in nmapData?.nmapHosts" :key="nmapHost.id">
              <p>Host ID: {{ nmapHost.id }}</p>
              <p>IP Address: {{ nmapHost.ipAddress }}</p>
              <p>Hostname: {{ nmapHost.hostname }}</p>
              <p>Info: {{ nmapHost.info }}</p>
              <p>Description: {{ nmapHost.description }}</p>
              <p>State: {{ nmapHost.state }}</p>

              <h3>Hostnames</h3>
              <ul>
                <li v-for="hostname in nmapHost.hostnames" :key="hostname.id">
                  <p>Hostname: {{ hostname.hostname }}</p>
                  <p>Type: {{ hostname.type }}</p>
                </li>
              </ul>

              <h3>Services</h3>
              <ul>
                <li v-for="service in nmapHost.services" :key="service.id" style="margin-top: 25px">
                  <p>Service ID: {{ service.id }}</p>
                  <p>Name: {{ service.name }}</p>
                  <p>State: {{ service.state }}</p>
                  <p>Port: {{ service.port }}</p>
                  <p>ServiceFP: {{ service.servicefp }}</p>
                  <p>Version: {{ service.version }}</p>
                  <p>Product: {{ service.product }}</p>
                  <p>CPE: {{ service.cpe }}</p>
                  <p>Protocol: {{ service.protocol }}</p>
                  <h4>Script Results</h4>
                  <ul>
                    <li v-for="scriptResult in service.scriptResults" :key="scriptResult.id">
                      <p>Name: {{ scriptResult.name }}</p>
                      <p>Output: {{ scriptResult.output }}</p>

                      <ul>
                        <li v-for="table in scriptResult.scriptResultTables" :key="table.id">
                          <ul>
                            <li v-for="element in table.scriptResultElements" :key="element.id">
                              {{ element.key }}: {{ element.value }}
                            </li>
                          </ul>
                        </li>
                      </ul>
                    </li>
                  </ul>
                </li>
              </ul>
            </div>
          </div>
        </va-card-content>
      </va-card>

      <va-card class="markup-tables mb-10">
        <va-card-content>
          <div class="container mt-1">
            <h1 class="mb-4">Scan Raw XML</h1>
            <!--pretty print an xml file/-->

            {{ nmapData?.raw }}
          </div>
        </va-card-content>
      </va-card>
    </div>

    <div class="flex justify-center mt-2"></div>
  </div>
</template>

<script setup lang="ts">
  import { ref } from 'vue'
  import { useColors } from 'vuestic-ui'
  import { onBeforeRouteUpdate, RouteParamValue, useRoute } from 'vue-router'
  import xmlFormat from 'xml-formatter'

  const { colors } = useColors()

  const nmapData = ref(null)
  const route = useRoute()
  const pretty = ref(null)

  fetch('http://localhost:9090/api/nmapscan/' + route.params.id)
    .then((response) => response.json())
    .then((data) => {
      nmapData.value = data
      pretty.value = xmlFormat(data.raw)
    })
  const basicAccordionValue = ref([false, false])
  let showHistory = ref([])

  function formatDate(timestamp) {
    const date = new Date(timestamp * 1000)
    return date.toLocaleString()
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
