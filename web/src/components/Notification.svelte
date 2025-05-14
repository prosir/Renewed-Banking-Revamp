<script lang="ts">
  import { onMount } from 'svelte';
  import { notify } from '../store/stores';
  import { fly } from 'svelte/transition';
  
  let notification = '';
  let visible = false;
  let timeoutId: ReturnType<typeof setTimeout> | null = null;
  
  notify.subscribe((message) => {
    if (message) {
      if (typeof message === 'string') {
        notification = message;
      } else if (typeof message === 'object') {
        if (message.message) {
          notification = message.message;
        } else if (message.toString && message.toString() !== '[object Object]') {
          notification = message.toString();
        } else {
          notification = 'Notification received';
        }
      } else {
        notification = String(message);
      }
      
      visible = true;
      
      if (timeoutId) {
        clearTimeout(timeoutId);
      }
      
      timeoutId = setTimeout(() => {
        visible = false;
        notify.set('');
      }, 5000);
    } else {
      visible = false;
    }
  });
  
  onMount(() => {
    return () => {
      if (timeoutId) {
        clearTimeout(timeoutId);
      }
    };
  });
</script>

{#if visible}
  <div 
    class="notification-container"
    transition:fly={{ y: -50, duration: 300 }}
  >
    <div class="notification">
      <div class="notification-content">
        <i class="fas fa-info-circle mr-2"></i>
        <span>{notification}</span>
      </div>
      <button 
        class="notification-close" 
        on:click={() => {
          visible = false;
          notify.set('');
        }}
      >
        <i class="fas fa-times"></i>
      </button>
    </div>
  </div>
{/if}

<style>
  .notification-container {
    position: fixed;
    top: 20px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 9999;
    width: auto;
    max-width: 90%;
  }
  
  .notification {
    display: flex;
    align-items: center;
    justify-content: space-between;
    background-color: var(--fleeca-card);
    border: 1px solid var(--fleeca-border);
    border-left: 4px solid var(--fleeca-green);
    color: var(--fleeca-text);
    padding: 12px 16px;
    border-radius: 6px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    min-width: 300px;
  }
  
  .notification-content {
    display: flex;
    align-items: center;
  }
  
  .notification-close {
    background: none;
    border: none;
    color: var(--fleeca-text-secondary);
    cursor: pointer;
    padding: 4px;
    margin-left: 12px;
    border-radius: 4px;
    transition: all 0.2s;
  }
  
  .notification-close:hover {
    background-color: var(--fleeca-hover);
    color: var(--fleeca-text);
  }
</style>
