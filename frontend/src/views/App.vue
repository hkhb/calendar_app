<template>
  <div id="app">
    <WidgetContainerModal />
    <router-view />
    <h1 style="background-color: yellow; padding: 20px;">これは App.vue からのメッセージです！</h1>
  </div>
</template>

<script lang="ts" setup>
  import { container as WidgetContainerModal } from 'jenesius-vue-modal';
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
