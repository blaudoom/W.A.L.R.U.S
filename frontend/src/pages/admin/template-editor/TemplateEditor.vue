<template>
  <div class="pt-6 grid grid-cols-2 gap-6">
    <va-card>
      <va-card-title>{{ t('forms.mediumEditor.title') }}</va-card-title>
      <va-card-content>
        <va-textarea v-model="template.template" :max-rows="rows" style="width: 100%; " :autosize="autoGrow">
        </va-textarea>
        <br />
        <br/>
        <va-button @click="save()">Save</va-button>
      </va-card-content>
    </va-card>
  </div>
</template>

<script setup lang="ts">
  import { nextTick, ref } from 'vue'
  import { useI18n } from 'vue-i18n'


  const { t } = useI18n()
  const template = ref([])
  const rows = ref(50)
  const autoGrow = ref(true)
  fetch('http://localhost:9090/api/template/report')
    .then((response) => response.json())
    .then((data) => {
      template.value = data
    })

  function save() {
    fetch('http://localhost:9090/api/template/report', {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(template.value),
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
  .medium-editor {
    a {
      @apply text-blue-700;
    }
  }
</style>
