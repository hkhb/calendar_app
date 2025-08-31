<script setup lang="ts">
import { format } from 'date-fns';
import { ja } from 'date-fns/locale';
import type { Schedule } from './ScheduleComponent.store';

const props = defineProps<{
  schedule: Schedule
}>();

// Date | string → Date に寄せる（ISO文字列もOK）
const toDate = (v: Date | string) => (v instanceof Date ? v : new Date(v));

// 表示フォーマット（例: 7/13(日) 08:00）
const fmt = (d: Date | string) =>
  format(toDate(d), 'HH:mm', { locale: ja });
</script>


<template>
  <!-- 中央寄せ -->
  <!-- <div class="items-center justify-center min-h-screen bg-orange-50"> -->
    <article
      class="w-full max-w-md rounded-lg border border-orange-200 bg-white p-6 shadow-sm hover:shadow-md transition-all duration-200"
    >
      <h3 class="text-2xl font-bold text-orange-600 mb-4 text-center">
        {{ schedule.name }}
      </h3>

      <div class="flex flex-wrap justify-center items-center gap-x-4 gap-y-2 mb-4">
        <div>
          <span class="font-medium text-orange-500">開始:</span>
          <span class="text-gray-800">{{ fmt(schedule.start_time) }}</span>
        </div>

        <div
          v-if="schedule.days"
          class="bg-orange-100 text-orange-700 px-2 py-0.5 rounded-md text-xs"
        >
          days: {{ schedule.days }}
        </div>

        <div>
          <span class="font-medium text-orange-500">終了:</span>
          <span class="text-gray-800">{{ fmt(schedule.finish_time) }}</span>
        </div>
      </div>

      <p
        v-if="schedule.event"
        class="mt-2 text-sm text-gray-700 border-t border-orange-100 pt-3 text-center"
      >
        {{ schedule.event }}
      </p>
    </article>
  <!-- </div> -->
</template>