<template>
  <div class="form-elements grid grid-cols-12 gap-6">
    <va-card class="col-span-6">
      <va-card-title>Import Nmap scan from XML</va-card-title>
      <va-card-content>
        <form method="POST" enctype="multipart/form-data" action="http://localhost:9090/api/nmap/import">
          <va-file-upload v-model="nmapXML" :disabled="disabled" dropzone file-types="xml" type="single" />

          <va-button :disabled="disabled" @click="upload">Import</va-button>
        </form>
        <va-alert v-model="success" color="success" closeable class="mb-6">
          <template #close> close </template>
          Import started! Please wait!.
        </va-alert>
      </va-card-content>
    </va-card>
  </div>
</template>
<script setup lang="ts">
  import { ref } from 'vue'
  import { NmapScanSpec } from '../../../components/ObjectClasses/NmapScan'

  const nmapXML = ref([])
  const disabled = ref(false)
  const success = ref(false)

  function upload() {
    let formData = new FormData()
    success.value = true
    disabled.value = true

    formData.append('method', 'POST')
    formData.append('file', nmapXML.value)
    const requestOptions = {
      method: 'POST',
      body: formData,
    }
    fetch('http://localhost:9090/api/nmap/import', requestOptions)
      .then((response) => {
        console.log(response.json())
      })
      .then((data) => {
        console.log(data)
        nmapXML.value = []
        success.value = false
        disabled.value = false
      })
  }
  function countDownTimer() {
    setTimeout(() => {
      disabled.value = false
      success.value = false
    }, 5000)
  }
</script>
