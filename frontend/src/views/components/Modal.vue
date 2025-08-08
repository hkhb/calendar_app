<template>
  <div class="modal-overlay" @click="onClose">
    <div class="modal" @click.stop>
      <p class="modal-message">{{ props.message }}</p>
      <button class="modal-close-button" @click="onClose">閉じる</button>
    </div>
  </div>
</template>

<script lang="ts" setup>
  import { closeModal } from 'jenesius-vue-modal';
  const props = defineProps<{ message: string }>();

  const onClose = async () => {
    // モーダルを閉じる
    await closeModal();
  }
</script>

<style scoped>
/* 背景の半透明オーバーレイ */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5); /* 半透明の黒 */
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

/* モーダル本体 */
.modal {
  background-color: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  max-width: 400px;
  width: 90%;
  text-align: center;
}

/* メッセージのスタイル */
.modal-message {
  margin-bottom: 20px;
  font-size: 16px;
  color: #333;
}

/* 閉じるボタン */
.modal-close-button {
  background-color: #007bff;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.modal-close-button:hover {
  background-color: #0056b3;
}
</style>