<template lang="pug">
  div
    v-card-title {{item.isNew ? 'Novo' : 'Editar'}} Item    
    v-form.mx-4
      v-text-field(
        v-model="itemToUpdate.name"
        label="Nome"
        hide-details="auto"
      )
      v-text-field(
        v-model="itemToUpdate.price"
        label="Preço"
        type="number"
        hide-details="auto"
      )
      v-textarea.mb-1(
        v-model="itemToUpdate.image_url"
        label="Url da imagem"
        rows="3"
      )
    v-card-actions
      v-btn(
        color="green"
        text
        @click="saveItem"
        :loading="isLoading"
      )
        v-icon mdi-check
      .container.d-flex.justify-end
        v-btn(
          color="red"
          text
          @click="cancelSave"
          :disabled="isDisabled"
        )
          v-icon mdi-cancel
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
      itemToUpdate: { ...this.item } || null,
      isDisabled: false,
      isLoading: false,
    };
  },
  mounted() {
    if (
      this.itemToUpdate.image_url ===
      'https://www.drupal.org/files/project-images/broken-image.jpg'
    )
      this.itemToUpdate.image_url = '';
  },
  methods: {
    async saveItem() {
      try {
        this.isLoading = true;
        this.isDisabled = true;
        let response;
        if (this.item.isNew) {
          response = await this.$axios.post(`product`, {
            ...this.itemToUpdate,
            imageUrl: this.itemToUpdate.image_url,
          });
        } else {
          response = await this.$axios.put(`product/${this.item._id}`, {
            ...this.itemToUpdate,
            imageUrl: this.itemToUpdate.image_url,
          });
        }
        this.$emit('updateItem', {
          ...response.data.data,
          isEdit: false,
          localId: this.item.localId,
          isNew: this.item.isNew,
        });
      } catch (err) {
      } finally {
        this.isLoading = false;
        this.isDisabled = false;
      }
    },
    cancelSave() {
      if (this.item.isNew) this.$emit('deleteItem', this.item);
      else this.$emit('updateItem', { ...this.item, isEdit: false });
    },
  },
};
</script>

<style lang="sass" scoped>
.img-size
  width: 200px
  height: 200px
</style>
