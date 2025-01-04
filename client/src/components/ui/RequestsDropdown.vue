<script setup lang="ts">
import { ref, onMounted, onUnmounted, nextTick } from "vue"
import { BackendRequest } from "@/models/Request.ts"

const props = defineProps<{
  requests: BackendRequest[]
  currentRequestId: string
}>()

const emit = defineEmits(["select"])
const isOpen = ref(false)
const dropdownButton = ref(null)
const dropdownList = ref(null)
const showAbove = ref(false)

const getCurrentRequest = () => {
  return props.requests.find((r) => r.id === props.currentRequestId)
}

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
  <div class="relative">
    <button
      ref="dropdownButton"
      @click="toggleDropdown"
      class="w-[330px] px-2 py-1.5 bg-white border border-stone-200 rounded text-sm flex items-center justify-between hover:bg-stone-50"
    >
      <span class="truncate">{{ getCurrentRequest()?.pathWithVerb }}</span>
      <svg
        class="w-4 h-4 ml-2"
        :class="{ 'rotate-180': isOpen }"
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 20 20"
        fill="currentColor"
      >
        <path
          fill-rule="evenodd"
          d="M5.23 7.21a.75.75 0 011.06.02L10 11.168l3.71-3.938a.75.75 0 111.08 1.04l-4.25 4.5a.75.75 0 01-1.08 0l-4.25-4.5a.75.75 0 01.02-1.06z"
          clip-rule="evenodd"
        />
      </svg>
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
          <span>{{ request.meta.method }}</span>
          <span class="truncate">{{ request.meta.path }}</span>
        </button>
      </div>
    </div>
  </div>
</template>
