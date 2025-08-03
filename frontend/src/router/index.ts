import { createRouter, createWebHistory, Router } from 'vue-router'; // Router をインポート

const routes = [
  {
    path: '/home',
    name: 'Home',
    component: () => import('../views/home/Home.vue') // Updated to use an existing component
  },
  {
    path: '/fixed-schedule',
    name: 'FixedSchedule',
    component: () => import('../views/FixedSchedule/Index.vue') // Updated to use alias '@' for correct path resolution
  }
];

const router: Router = createRouter({ // 型を明示的に指定
  history: createWebHistory(),
  routes,
});

export default router;