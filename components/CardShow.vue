<template lang="pug">
  div
    v-img.img-size(:for="item.name" :src="item.image_url" @error="item.image_url = 'https://www.drupal.org/files/project-images/broken-image.jpg'")
    v-card-title.d-inline-block.text-truncate {{ item.name }}
    v-card-subtitle.mt-n5 {{ item.price.toLocaleString('pt-br',{style: 'currency', currency: 'BRL'}) }}
    v-card-actions
      v-btn(
        color="orange"
        text
        :disabled="isDisabled"
        @click="$emit('editItem', {...item, isEdit: true})"
      )
        v-icon mdi-pencil
      .container.d-flex.justify-end
        v-btn(
          color="red"
          text
          :loading="isLoading"
          @click="deleteItem"
        )
          v-icon mdi-delete
</template>

<script>
export default {
  props: {
    item: {
      type: Object,
      default: null,
    },
  },
  data() {
    return {
      isDisabled: false,
      isLoading: false,
    };
  },
  methods: {
    async deleteItem() {
      try {
        this.isLoading = true;
        this.isDisabled = true;
        await this.$axios.delete(`product/${this.item._id}`);
        this.$emit('deleteItem', this.item);
      } catch (err) {
      } finally {
        this.isLoading = false;
        this.isDisabled = false;
      }
    },
  },
};
</script>

<style lang="sass" scoped>
.img-size
  width: 200px
  height: 200px
.text-truncate
  max-width: 190px
</style>
