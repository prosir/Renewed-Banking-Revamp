<div class="fixed inset-0 bg-black bg-opacity-70 flex items-center justify-center z-50 animate-fadeIn">
  <div class="max-w-[400px] w-full bg-fleeca-card p-8 rounded-lg shadow-card">
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
  .max-w-\[50rem\] {
      max-width: 50rem;
  }
  .max-h-\[25rem\] {
      max-height: 25rem;
  }
  .w-full {
      width: 100%;
  }
  .h-full {
      height: 100%;
  }
  .bg-primary {
      background-color: var(--clr-primary);
  }
  .p-20 {
      padding: 5rem;
  }
  .rounded-\[1rem\] {
      border-radius: 1rem;
  }
  .relative {
      position: relative;
  }
  .w-20 {
      width: 5rem;
  }
  .h-20 {
      height: 5rem;
  }
  .left-\[40\%\] {
      left: 40%;
  }
  .top-\[25\%\] {
      top: 25%;
  }
  .absolute {
      position: absolute;
  }
  .border-4 {
      border-width: 4px;
  }
  .border-t-white {
      border-top-color: white;
  }
  .border-opacity-30 {
      border-opacity: 0.3;
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
  @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
  }
  .animate-fadeIn {
      animation: fadeIn 0.3s ease-in-out forwards;
  }
  .animate-shimmer {
      animation: shimmer 2s linear infinite;
      background-size: 200% 100%;
      background-image: linear-gradient(to right, #00A550, #00D66A, #00A550);
  }
  @keyframes shimmer {
      0% {
          background-position: -100% 0;
      }
      100% {
          background-position: 100% 0;
      }
  }
</style>
