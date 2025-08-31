<template>
  <AppHeader />
  <div class="fixed-schedule-index">
    <div class="p-6 bg-white rounded-lg shadow-md">
      <h2 class="text-2xl font-semibold text-gray-800 mb-4">シフトパターン一覧（ダミー）</h2>

      <div
        v-for="(schedule, index) in schedules"
        :key="index"
        class="mb-6 border border-gray-200 rounded p-4"
      >
        <ScheduleCard :schedule="schedule" />
      </div>
    </div>
  </div>
</template>
<script lang="ts" setup>
  import { ref, getCurrentInstance } from 'vue' // getCurrentInstance をインポート
  import { format } from 'date-fns'
  import AppHeader from '../components/AppHeader.vue';
  import { openModal } from 'jenesius-vue-modal';
  import Modal from '../components/Modal.vue';
  import ScheduleCard from '../components/ScheduleComponent/ScheduleCard.vue';

const schedules = ref([
        {
          name: '早番',
          start_time: new Date(2025, 6, 13, 8, 0),
          finish_time: new Date(2025, 6, 13, 17, 0),
          days: 5,
          event: '早朝からの勤務シフト'
        },
        {
          name: '遅番',
          start_time: new Date(2025, 6, 13, 13, 0),
          finish_time: new Date(2025, 6, 13, 22, 0),
          days: 3,
          event: '午後からの勤務シフト'
        }
      ])

  async function onEdit() {
    const modal = await openModal(Modal, { message: 'シフトを追加しますか？' });
  }

const onDelete = () => {
  if (confirm('本当に削除しますか？')) {
    console.log('削除処理を実行')
  }
}
</script>