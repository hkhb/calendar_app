<template>
  <div id="app">
    <AppHeader />
    <router-view />
  </div>
</template>

<script lang="ts">
  import AppHeader  from './components/AppHeader.vue';

  export default {
  name: 'App',
  components: {
    AppHeader, // ✅ ここに登録しないと <Header /> は使えません
  },
};
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
