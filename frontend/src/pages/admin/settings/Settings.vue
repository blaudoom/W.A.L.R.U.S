<template>
  <div class="dashboard">
    <div class="pt-6 grid grid-cols-1 gap-6">
      <va-card class="markup-tables mb-10">
        <va-card-content>
          <div class="container mt-1">
            <h1 class="mb-4">Settings</h1>
            <table
              class="va-table va-table--striped va-table--hoverable w-full w-full table table-bordered table-responsive"
            >
              <tr>
                <th>Name</th>
                <th>Value</th>
                <th>Actions</th>
              </tr>
              <tr v-for="(setting, index) in settings">
                <td>{{ setting?.name }}</td>
                <td>
                  <template v-if="!showEdit[index]">
                    {{ setting?.value }}
                  </template>
                  <template v-if="showEdit[index]">
                    <input v-model="setting.value" type="text" />
                    <va-button @click="save(index)">Save</va-button>
                  </template>
                </td>
                <td>
                  <va-button @click="edit(index)"><va-icon name="material-icons-edit"></va-icon></va-button>
                </td>
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

  const settings = ref([])
  const showEdit = ref([])

  fetch('http://localhost:9090/api/settings/')
    .then((response) => response.json())
    .then((data) => {
      settings.value = data
      settings.value.forEach((setting, index) => {
        showEdit.value[index] = false
      })
    })

  function edit(index) {
    showEdit.value[index] = !showEdit.value[index]
  }

  function save(index) {
    showEdit.value[index] = !showEdit.value[index]
    fetch('http://localhost:9090/api/settings/', {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(settings.value[index]),
    })
      .then((response) => response.json())
      .then((data) => {
        console.log('Success:', data)
      })
      .catch((error) => {
        console.error('Error:', error)
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
</style>
