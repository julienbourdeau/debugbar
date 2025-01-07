<script setup lang="ts">
import { ref, onMounted, onUnmounted, nextTick, computed } from "vue"
import { BackendRequest } from "@/models/Request.ts"
import HttpVerb from "@/components/ui/HttpVerb.vue"
import { ChevronUpDownIcon } from "@heroicons/vue/16/solid"
import { extractAfterPath } from "../../helpers.ts"

const props = defineProps<{
  requests: BackendRequest[]
  currentRequestId: string
}>()

const emit = defineEmits(["select"])
const isOpen = ref(false)
const dropdownButton = ref(null)
const dropdownList = ref(null)
const showAbove = ref(false)

const currentRequest = computed(() => {
  return props.requests.find((r) => r.id === props.currentRequestId)
})

const handleSelect = (requestId) => {
  emit("select", requestId)
  isOpen.value = false
}

const updatePosition = () => {
  if (!isOpen.value || !dropdownButton.value || !dropdownList.value) return

  const buttonRect = dropdownButton.value.getBoundingClientRect()
  const dropdownHeight = dropdownList.value.offsetHeight
  const windowHeight = window.innerHeight
  const spaceBelow = windowHeight - buttonRect.bottom
  const spaceAbove = buttonRect.top

  // Show above if there's not enough space below and more space above
  showAbove.value = spaceBelow < dropdownHeight && spaceAbove > spaceBelow
}

// Update position when opening dropdown
const toggleDropdown = () => {
  isOpen.value = !isOpen.value
  if (isOpen.value) {
    // Use nextTick to ensure the dropdown is rendered before measuring
    nextTick(updatePosition)
  }
}

// Update position on scroll or resize
onMounted(() => {
  window.addEventListener("scroll", updatePosition, true)
  window.addEventListener("resize", updatePosition)
})

onUnmounted(() => {
  window.removeEventListener("scroll", updatePosition, true)
  window.removeEventListener("resize", updatePosition)
})
</script>

<template>
  <div class="">
    <button
      ref="dropdownButton"
      @click="toggleDropdown"
      class="w-[360px] px-2 py-1.5 bg-white border border-stone-200 rounded text-sm flex items-center justify-start space-x-1.5 hover:bg-stone-50"
    >
      <http-verb :verb="currentRequest.request.method" />
      <span class="truncate grow text-left">
        <span class="text-stone-900">{{ currentRequest.request.url.pathname }}</span>
        <span class="text-stone-500">{{ extractAfterPath(currentRequest.request.url) }}</span>
      </span>
      <chevron-up-down-icon class="size-4" :class="{ 'rotate-180': isOpen }" />
    </button>

    <div
      v-if="isOpen"
      ref="dropdownList"
      class="absolute z-50 w-full bg-white border border-stone-200 rounded-md shadow-lg max-h-60 overflow-auto"
      :class="{
        'bottom-[calc(100%+0.25rem)]': showAbove,
        'mt-1': !showAbove,
      }"
    >
      <div class="py-1">
        <button
          v-for="request in requests"
          :key="request.id"
          @click="handleSelect(request.id)"
          class="w-full px-2 py-1.5 flex items-center justify-start space-x-2 text-sm hover:bg-stone-200"
          :class="{ 'bg-stone-100': request.id === currentRequestId }"
        >
          <http-verb :verb="request.request.method" />
          <span class="">
            <span class="text-stone-900">{{ request.request.url.pathname }}</span>
            <span class="text-stone-500">{{ extractAfterPath(request.request.url) }}</span>
          </span>
        </button>
      </div>
    </div>
  </div>
</template>
