<template>
  <div class="dashboard">
    <div class="pt-6 grid grid-cols-1 gap-6">
      <va-card class="markup-tables mb-10">
        <va-card-content>
          <div class="container mt-5">
            <h1 class="mb-4">Host Information</h1>
            <table
              class="va-table va-table--striped va-table--hoverable w-full w-full table table-bordered table-responsive"
            >
              <tr>
                <td>ID</td>
                <td>{{ target?.id }}</td>
              </tr>
              <tr>
                <td>IP Address</td>
                <td>{{ target?.ipAddress }}</td>
              </tr>
              <tr>
                <td>Hostname</td>
                <td>{{ target?.hostname }}</td>
              </tr>
              <tr>
                <td>State</td>
                <td>{{ target?.state }}</td>
              </tr>
            </table>

            <h2 class="mt-4">Services</h2>
            <table class="w-full va-table va-table--striped va-table--hoverable table table-bordered table-responsive">
              <tr>
                <th>Name</th>
                <th>State</th>
                <th>Port</th>
                <th>CPE</th>
                <th>Notes / Script outputs</th>
                <th>Fingerprint</th>
                <th>Seen on scans</th>
                <th>Actions</th>
              </tr>
              <template v-for="(service, sindex) in target?.services || []">
                <tr>
                  <td>{{ service.name }} <va-icon name="material-icons-edit" @click="editName(sindex)"></va-icon></td>
                  <td>{{ service.state }} ({{ service.reason }})</td>
                  <td>{{ service.protocol }} / {{ service.port }}</td>
                  <td>{{ service.cpe }}</td>
                  <td style="width: 30%">
                    <p v-if="service.serviceNotes.length > 0" class="tinyheader">Notes:</p>
                    <div v-for="note in service?.serviceNotes" style="margin: 2px">
                      <strong>{{ note.title }} : </strong>{{ note.content }}
                    </div>
                    <p v-if="service.scriptResults.length > 0" class="tinyheader">Scripts:</p>
                    <div v-for="result in service?.scriptResults">
                      <strong>{{ result.title }} : </strong>{{ result.content }}
                      <va-accordion v-if="result.scriptResultTables?.length > 0" v-model="showAccordion[sindex].result">
                        <va-collapse :header="'Script elements:'" :flat="true">
                          <div v-for="table in result.scriptResultTables" style="margin-top: 15px">
                            <p
                              v-for="element in table.scriptResultElements"
                              style="margin-left: 15px; white-space: normal; word-break: break-all"
                            >
                              <strong>{{ element.key }}</strong> : {{ element.value }}
                            </p>
                            <br />
                          </div>
                        </va-collapse>
                      </va-accordion>
                    </div>
                  </td>
                  <td>
                    <va-accordion v-if="service.servicefp" v-model="showAccordion[sindex].fp">
                      <va-collapse :header="'Fingerprint'">
                        <div class="p-4">
                          <div style="background-color: white; padding: 25px">
                            {{ service.servicefp }}
                          </div>
                        </div>
                      </va-collapse>
                    </va-accordion>
                  </td>
                  <td>
                    <template v-for="(scan, index) in service.seenOnScanId">
                      <template v-if="index > 0">,</template>
                      <router-link
                        :to="{
                          name: 'scanDetails',
                          params: {
                            id: scan.scanId,
                          },
                        }"
                        ><span>{{ scan.scanOrdinal }}</span></router-link
                      >
                    </template>
                  </td>
                  <td>
                    <va-button class="action-button" @click="show(sindex)">
                      <va-icon class="icon-left" name="material-icons-history" title="Show history" />
                    </va-button>
                    <va-button @click="addNote(sindex)">
                      <va-icon class="icon-left" name="material-icons-add" />
                    </va-button>
                  </td>
                </tr>
                <tr></tr>
                <tr v-show="showHistory[sindex]">
                  <td colspan="7">
                    <table>
                      <tr>
                        <th>Nmap run #</th>
                        <th>Name</th>
                        <th>State</th>
                        <th>Port</th>
                        <th>CPE</th>
                        <th>Notes / Script outputs</th>
                        <th>Fingerprint</th>
                      </tr>
                      <tr v-for="(serviceIteration, i) in service?.targetServiceIterations">
                        <router-link
                          :to="{
                            name: 'scanDetails',
                            params: {
                              id: serviceIteration.seenOnScanDto?.scanId,
                            },
                          }"
                        >
                          <td>{{ serviceIteration.seenOnScanDto?.scanOrdinal }}</td>
                        </router-link>
                        <td>{{ serviceIteration.name }}</td>
                        <td>{{ serviceIteration.state }}</td>
                        <td>{{ serviceIteration.protocol }} / {{ serviceIteration.port }}</td>
                        <td>{{ serviceIteration.cpe }}</td>
                        <td>
                          <p v-if="serviceIteration.scriptResults.length > 0" class="tinyheader">Scripts:</p>
                          <div v-for="result in serviceIteration?.scriptResults" style="margin: 2px">
                            <strong>{{ result.title }} : </strong>{{ result.content }}
                          </div>
                        </td>
                        <td>
                          <va-accordion v-if="serviceIteration.servicefp" v-model="showAccordion[sindex].accordion[i]">
                            <va-collapse :header="'Fingerprint'">
                              <div class="p-4">
                                <div style="background-color: white; padding: 25px">
                                  {{ serviceIteration.servicefp }}
                                </div>
                              </div>
                            </va-collapse>
                          </va-accordion>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr></tr>
                <tr v-show="showNewNote[sindex]">
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
                  <td style="width: 30%; background-color: whitesmoke; padding: 10px; margin-bottom: 10px">
                    <va-input
                      id="title"
                      v-model="newNote.title"
                      type="text"
                      :label="'Title'"
                      class="form-control white"
                      placeholder="Add title!"
                    />
                    <br />
                    <va-textarea
                      id="comment"
                      v-model="newNote.content"
                      :label="'Note'"
                      class="form-control white"
                      placeholder="Add your own note!"
                    />
                    <br />
                    <br />
                    <va-button
                      id="noteCancelButton"
                      :label="'Cancel'"
                      style="float: left"
                      :color="'#dc3545'"
                      @click="cancelNoteDialog(sindex)"
                      >Cancel
                    </va-button>
                    <va-button
                      id="noteSaveButton"
                      :label="'Save'"
                      style="float: right"
                      @click="addNoteToService(service.id)"
                      >Save
                    </va-button>
                  </td>
                  <td></td>
                  <td></td>
                  <td></td>
                </tr>
              </template>
            </table>

            <h2 class="mt-4">Hostnames</h2>
            <table
              class="va-table va-table--striped va-table--hoverable w-full w-full table table-bordered table-responsive"
            >
              <tr>
                <th>Hostname</th>
                <th>Type</th>
              </tr>
              <tr v-for="hostname in target?.hostnames || []">
                <td>{{ hostname.hostname }}</td>
                <td>{{ hostname.type }}</td>
              </tr>
            </table>
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
  import { useRoute } from 'vue-router'

  const { colors } = useColors()

  const target = ref(null)
  const route = useRoute()
  let showHistory = ref([])
  let showNewNote = ref([])
  let showAccordion = ref([])
  let showNameEdit = ref([])
  const newNote = ref({ content: '', serviceId: 0, title: '' })
  const noteResponse = ref(null)

  function getData() {
    fetch('http://localhost:9090/api/target/' + route.params.id)
      .then((response) => response.json())
      .then((data) => {
        target.value = data
        target.value.services.forEach((value, index) => {
          showHistory.value[index] = false
          showNewNote.value[index] = false
          showNameEdit.value[index] = false
          showAccordion.value[index] = { result: [false, false], fp: [false, false], accordion: [] }
          value.targetServiceIterations.forEach((iteration, i) => {
            showAccordion.value[index].accordion[i] = [false, false]
          })
        })
      })
  }

  getData()
  // const basicAccordionValue = ref([false, false])

  function show(index) {
    showHistory.value[index] = !showHistory.value[index]
  }

  function addNote(index) {
    showNewNote.value[index] = !showNewNote.value[index]
  }

  function cancelNoteDialog(index) {
    showNewNote.value[index] = false
  }

  function addNoteToService(serviceId) {
    newNote.value.serviceId = serviceId
    const requestOptions = {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(newNote.value),
    }
    fetch('http://localhost:9090/api/note/', requestOptions)
      .then((response) => response.json())
      .then((data) => {
        noteResponse.value = data
        newNote.value = { content: '', serviceId: 0, title: '' }
        getData()
      })
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

  .tinyheader {
    font-size: 10px;
    font-weight: bold;
    text-decoration: underline;
  }
  .white div {
    background-color: white;
  }
  .action-button {
    margin-right: 5px;
    padding: 1px;
  }
</style>
