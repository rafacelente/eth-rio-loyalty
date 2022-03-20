<template>
  <div class="wrapper" @click="$emit('clicked', reward.value)">
      <div class="title">
          {{ reward.title }}
      </div>
      <div class="cost">
        {{ reward.value }}
        <v-icon small >mdi-star</v-icon>
      </div>
  </div>
</template>

<script>
export default {
  props: {
    reward: {
      type: Object,
      required: true
    }
  }
}
</script>

<style>
  .wrapper {
    display:flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    padding: 8px 16px;
    background: #403999;
  }
  .cost {
    display: flex;
    flex-direction: row;
    align-items: center;
    column-gap: 8px;
  }
</style>
