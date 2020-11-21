<template lang="pug">  
  v-app()
    v-app-bar(:clipped-left="clipped" fixed app color="indigo darken-3" dark)
      b Be
      span Growth
    v-main
      v-container
        nuxt
    v-footer(:absolute="!fixed" app)
      span &copy; Developed by Gabriell Lucas {{ new Date().getFullYear() }}
</template>

<script>
export default {
  data() {
    return {
      clipped: false,
      drawer: false,
      fixed: false,
      title: 'Vuetify.js',
    };
  },
};
</script>
