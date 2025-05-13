<script>
  import { notify } from "../store/stores";
  import { fly } from 'svelte/transition';

  $: notificationData = typeof $notify === 'object'
    ? $notify
    : { message: $notify, type: 'info' };

  $: notificationType = notificationData.type || 'info';
  $: notificationIcon = notificationType === 'error'
    ? 'fa-circle-exclamation'
    : notificationType === 'success'
      ? 'fa-circle-check'
      : 'fa-circle-info';

  $: notificationColor = notificationType === 'error'
    ? 'text-red-500 bg-red-500/10 border-red-500/20'
    : notificationType === 'success'
      ? 'text-green-500 bg-green-500/10 border-green-500/20'
      : 'text-fleeca-green bg-fleeca-green/10 border-fleeca-green/20';
</script>

{#if $notify}
  <div 
    class="fixed right-[5%] top-[5%] z-50 max-w-md"
    transition:fly={{ x: 20, duration: 300 }}
  >
    <div class="bg-fleeca-card rounded-lg shadow-card overflow-hidden animate-slideUp border border-fleeca-border">
      <div 
        class="h-1 bg-gradient-to-r"
        class:from-red-500={notificationType === 'error'}
        class:to-red-400={notificationType === 'error'}
        class:from-green-500={notificationType === 'success'}
        class:to-green-400={notificationType === 'success'}
        class:from-fleeca-green={notificationType === 'info'}
        class:to-fleeca-light-green={notificationType === 'info'}
      ></div>
      <div class="p-4 flex items-start">
        <div class={`w-8 h-8 rounded-full flex items-center justify-center mr-3 flex-shrink-0 ${notificationColor}`}>
          <i class={`fa-solid ${notificationIcon}`}></i>
        </div>
        <div class="flex-1">
          <div class="text-fleeca-text font-medium">
            {#if notificationData.title}
              <div class="font-semibold mb-1">{notificationData.title}</div>
            {/if}
            <div>{notificationData.message || notificationData}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
{/if}
