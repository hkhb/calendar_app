<template>
  <div class="fixed-schedule-index">
    <RegularSchedule />
  </div>
</template>
<script>
  import RegularSchedule from './components/index.vue';

  export default {
    name: 'FixedScheduleIndex',
    components: {
      RegularSchedule
    }
  };
</script>