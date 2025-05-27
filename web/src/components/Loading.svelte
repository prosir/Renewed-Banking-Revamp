<div class="fixed inset-0 bg-black bg-opacity-70 flex items-center justify-center z-50 animate-fadeIn">
  <div class="max-w-md w-full bg-fleeca-card p-8 rounded-lg shadow-card">
    <div class="flex flex-col items-center justify-center">
      <div class="relative w-24 h-24 mb-6">
        <div class="absolute inset-0 rounded-full border-4 border-fleeca-bg"></div>
        <div class="absolute inset-0 rounded-full border-4 border-transparent border-t-fleeca-green animate-spin"></div>
        <div class="absolute inset-0 flex items-center justify-center">
          <i class="fas fa-university text-fleeca-green text-2xl"></i>
        </div>
      </div>
      <h3 class="text-xl font-semibold text-fleeca-text mb-2 font-display">Processing Transaction</h3>
      <p class="text-fleeca-text-secondary text-center">Please wait while we process your request...</p>
      <div class="w-full h-1 bg-fleeca-bg rounded-full mt-6 overflow-hidden">
        <div class="h-full bg-fleeca-green animate-pulse" style="width: 100%;"></div>
      </div>
    </div>
  </div>
</div>

<style>
  @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
  }
  .animate-fadeIn {
      animation: fadeIn 0.3s ease-in-out forwards;
  }
  .fixed {
      position: fixed;
  }
  .inset-0 {
      top: 0;
      right: 0;
      bottom: 0;
      left: 0;
  }
  .flex {
      display: flex;
  }
  .items-center {
      align-items: center;
  }
  .justify-center {
      justify-content: center;
  }
  .max-w-md {
      max-width: 28rem;
  }
  .w-full {
      width: 100%;
  }
  .h-full {
      height: 100%;
  }
  .p-8 {
      padding: 2rem;
  }
  .rounded-lg {
      border-radius: 0.5rem;
  }
  .relative {
      position: relative;
  }
  .w-24 {
      width: 6rem;
  }
  .h-24 {
      height: 6rem;
  }
  .absolute {
      position: absolute;
  }
  .border-4 {
      border-width: 4px;
  }
  .rounded-full {
      border-radius: 9999px;
  }
  .animate-spin {
      animation: spin 1s linear infinite;
  }
  @keyframes spin {
      to {
          transform: rotate(360deg);
      }
  }
</style>
