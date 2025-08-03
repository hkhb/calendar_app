<template>
  <AppHeader />
  <div>
    <h1>Welcome to Your Calendar App!</h1>
    <p>This is the home page.</p>
    <router-link to="/fixed-schedule">Go to Fixed Schedule</router-link>
  </div>
</template>

<script lang="ts" setup>
  import AppHeader from '../components/AppHeader.vue';

</script>

<style scoped>
  /* Add your styles here */
</style>
