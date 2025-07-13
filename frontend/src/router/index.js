import { createRouter, createWebHistory } from 'vue-router';

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('../App.vue') // You might want a dedicated Home component
  },
  {
    path: '/fixed-schedule',
    name: 'FixedSchedule',
    component: () => import('../FixedSchedule/FixedSeheduleIndex.vue')
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
