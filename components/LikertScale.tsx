
import React from 'react';

interface LikertScaleProps {
  value: number;
  onChange: (val: number) => void;
}

export const LikertScale: React.FC<LikertScaleProps> = ({ value, onChange }) => {
  const labels = ['Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree'];
  
  return (
    <div className="w-full space-y-8 py-6">
      <div className="flex justify-between items-center relative px-2">
        <div className="absolute top-1/2 left-4 right-4 h-[2px] bg-zinc-800 -translate-y-1/2 -z-0" />
        {[1, 2, 3, 4, 5].map((num) => (
          <button
            key={num}
            onClick={() => onChange(num)}
            className={`
              w-12 h-12 rounded-full flex items-center justify-center font-bold text-lg z-10 transition-all duration-300 transform
              ${value === num 
                ? 'bg-[#D4AF37] text-black scale-125 shadow-[0_0_20px_rgba(212,175,55,0.4)]' 
                : 'bg-zinc-900 text-zinc-400 border border-zinc-700 hover:border-[#D4AF37]'}
            `}
          >
            {num}
          </button>
        ))}
      </div>
      
      <div className="flex justify-between px-1">
        <span className="text-xs text-zinc-500 font-medium uppercase tracking-wider">{labels[0]}</span>
        <span className="text-xs text-zinc-500 font-medium uppercase tracking-wider">{labels[4]}</span>
      </div>
    </div>
  );
};
