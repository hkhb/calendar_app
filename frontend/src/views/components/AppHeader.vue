<template>
  <div class="header">
    <h1>My Application Header</h1>
    <nav>
      <ul>
        <li><router-link to="/home">Home</router-link></li>
        <li><router-link to="/Fixed-Schedule">FixedSchedule</router-link></li>
      </ul>
    </nav>
  </div>
</template>
<script lang="ts">
import { defineComponent } from 'vue';
  export default defineComponent({
    name: 'AppHeader',
  });
</script>