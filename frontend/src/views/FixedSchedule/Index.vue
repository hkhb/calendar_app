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
        <h3 class="text-xl font-bold text-blue-600">{{ schedule.name }}</h3>

        <div class="flex justify-between mt-4 text-sm text-gray-700 gap-4">
          <div class="flex-1 text-center">
            <p class="font-semibold text-orange-600">開始時刻</p>
            <p>{{ format(schedule.start_time, 'HH:mm') }}</p>
          </div>

          <div class="flex-1 text-center">
            <p class="font-semibold text-orange-600">日数</p>
            <p>{{ schedule.days }} 日間</p>
          </div>

          <div class="flex-1 text-center">
            <p class="font-semibold text-orange-600">終了時刻</p>
            <p>{{ format(schedule.finish_time, 'HH:mm') }}</p>
          </div>
        </div>

        <p class="mt-2 text-gray-600">
          <span class="font-semibold">説明:</span> {{ schedule.event }}
        </p>
        <div>
          <button @click="onEdit" class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">
            追加
          </button>
          <button @click="onDelete" class="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600 ml-2">
            削除
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
<script lang="ts" setup>
  import { ref, getCurrentInstance } from 'vue' // getCurrentInstance をインポート
  import { format } from 'date-fns'
  import AppHeader from '../components/AppHeader.vue';

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

const onEdit = () => {
  const instance = getCurrentInstance();
  if (instance && instance.appContext.config.globalProperties.$modal) {
    instance.appContext.config.globalProperties.$modal.open({
      title: '編集',
      content: 'ここにフォームなど',
      buttons: [
        {
          text: '閉じる',
          action: () => instance.appContext.config.globalProperties.$modal.close()
        }
      ]
    });
  } else {
    alert('Modal service not available.');
  }
};

const onDelete = () => {
  if (confirm('本当に削除しますか？')) {
    console.log('削除処理を実行')
  }
}
</script>