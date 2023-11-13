<template>
  <div v-if="project && project.targets" class="pt-6 grid grid-cols-1 gap-6">
    <va-card class="markup-tables mb-8">
      <va-card-title> Nmap Scans for project </va-card-title>
      <va-card-content>
        <table class="va-table w-full">
          <thead>
            <tr>
              <th>ID</th>
              <th>Time</th>
            </tr>
          </thead>

          <tbody>
            <tr v-for="scan in project.nmapScans" :key="scan.id">
              <td>{{ scan.id }}</td>
              <td>{{ new Date(scan.startTime * 1000) }}</td>
            </tr>
          </tbody>
        </table>
      </va-card-content>
    </va-card>
  </div>
  <div v-if="project && project.targets" class="pt-6 grid grid-cols-1 gap-6">
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
              <td>{{ target.ipAddress }}</td>
              <td>{{ target.hostname }}</td>
            </tr>
          </tbody>
        </table>
      </va-card-content>
    </va-card>
  </div>
</template>

<script setup lang="ts">
  import { ref } from 'vue'
  import { useI18n } from 'vue-i18n'
  import { VaCard, VaCardContent, VaCardTitle, VaButton, VaImage, useColors } from 'vuestic-ui'
  import data from '../../../data/tables/markup-table/data.json'
  import { Project } from '../../../components/ObjectClasses/Project'

  const { t } = useI18n()

  const users = ref(data.slice(0, 8))
  const project = ref(null)

  const { colors } = useColors()

  fetch('http://localhost:9090/api/project/active')
    .then((response) => response.json())
    .then((data) => (project.value = data))

  const infoTiles = ref([
    {
      color: 'success',
      value: '803',
      text: 'commits',
      icon: '',
    },
    {
      color: 'danger',
      value: '57',
      text: 'components',
      icon: '',
    },
    {
      color: 'info',
      value: '5',
      text: 'teamMembers',
      icon: '',
    },
  ])

  const modal = ref(false)
  const currentImageIndex = ref(0)
  const images = ref([
    'https://i.imgur.com/qSykGko.jpg',
    'https://i.imgur.com/jYwT08D.png',
    'https://i.imgur.com/9930myH.jpg',
    'https://i.imgur.com/2JxhWD6.jpg',
    'https://i.imgur.com/MpiOWbM.jpg',
  ])

  function showModal() {
    modal.value = true
  }
</script>
<script lang="ts">
  import { Project } from '../../../components/ObjectClasses/Project'

  export default {
    name: 'DashboardInfoBlock',
    props: {
      project: Project,
    },
  }
</script>

<style lang="scss" scoped>
  .row-separated {
    .flex + .flex {
      border-left: 1px solid var(--va-background-primary);
    }
  }

  .rich-theme-card-text {
    line-height: 1.5;
  }

  .gallery-carousel {
    width: 80vw;
    max-width: 100%;

    @media all and (max-width: 576px) {
      width: 100%;
    }
  }
</style>
