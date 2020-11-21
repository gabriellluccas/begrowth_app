<template lang="pug">
  .container
    v-data-iterator.backgroud-grey(
      :items="items"
      :loading='actions.isLoading'
      :items-per-page="filter.value"  
      :page="filter.page"
      hide-default-footer
    )
      template(v-slot:default="{ items }")
        v-row
          v-col(rows="12" md="3" sm="6" v-for="item in items" :key="item._id")
            v-card.card-size(class="mx-auto")
              CardShow(
                v-if="!item.isEdit" 
                :item="item" 
                @editItem="updateList"
                @deleteItem="removeItem"
              )
              CardEdit(
                v-else 
                :item="item"
                @updateItem="updateList"
                @createItem="addItem"
                @deleteItem="removeItem"
              )

      template(v-slot:loading)
        .container.my-10.d-flex.justify-center
          v-progress-circular(
            size="50"
            indeterminate
            color="indigo darken-5"
          )
      template(v-slot:header)
        v-toolbar(
          class="mb-2"
          color="indigo lighten-1"
          dark
          flat
        )
          .container.d-flex.justify-start.align-center
            v-toolbar-title 
              b Produtos
          .container.d-flex.justify-end
            v-btn.mx-1(
              x-small
              fab
              dark
              color="white"
              class="mr-1"
              @click="addItem"
            )
              v-icon(color="indigo darken-5") mdi-plus
      template(v-slot:footer="{pagination: {pageCount}}")
        v-toolbar(
          class="mb-2"
          color="indigo lighten-1"
          dark
          flat
        )
          .container.d-flex.justify-start.align-center
            v-select.footer-select(v-model="filter.value" :items="filter.items" @change="filter.page = 1" hide-details)
            b.ml-4 items por pagina
          .container.d-flex.justify-end 
            v-btn.mx-2(
              x-small
              fab
              dark
              color="white"
              class="mr-1"
              @click="filter.page > 1 ? filter.page-- : filter.page"
            )
              v-icon(color="indigo darken-5") mdi-chevron-left
            b.d-flex.align-center.mx-2(color="white") {{filter.page}} de {{pageCount}}
            v-btn.mx-1(
              x-small
              fab
              dark
              color="white"
              class="mr-1"
              @click="filter.page < pageCount ? filter.page++ : filter.page"
            )
              v-icon(color="indigo darken-5") mdi-chevron-right

</template>
<script>
import CardShow from '../components/CardShow';
import CardEdit from '../components/CardEdit';

export default {
  components: [CardShow, CardEdit],
  data() {
    return {
      items: [],
      filter: { items: [4, 8, 12, 16], value: 8, page: 1 },
      actions: {
        isLoading: true,
      },
      count: 0,
    };
  },
  mounted() {
    this.listProducts();
  },
  methods: {
    async listProducts() {
      try {
        const {
          filter: { value, page },
        } = this;
        this.actions.isLoading = true;
        const response = await this.$axios.get(
          `product?filter=${value}&page=${page}`
        );
        this.items = response?.data.data || [];
        this.actions.isLoading = false;
      } catch (err) {}
    },
    updateList(item) {
      this.items = this.items.map((el) => {
        if (item.isNew)
          return el.localId === item.localId ? { ...item, isNew: false } : el;
        else return el._id === item._id ? item : el;
      });
    },
    removeItem(item) {
      if (item.isNew)
        this.items = this.items.filter((el) => el.localId !== item.localId);
      else this.items = this.items.filter((el) => el._id !== item._id);
    },
    addItem() {
      const newItems = [
        { isNew: true, isEdit: true, localId: this.count },
        ...this.items,
      ];
      this.items = newItems.map((el, index) => ({
        ...el,
        localId: el._id || el.localId,
      }));
      this.count++;
    },
  },
};
</script>

<style lang="sass" scoped>
.card-size
  width: 200px
  height: 350px
.filter
  min-width: 50px
.footer-select
  max-width: 50px
</style>
